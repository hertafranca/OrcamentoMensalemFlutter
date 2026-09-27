import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../services/local_storage_service.dart';
import '../utils/date_formatter.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_budget_card.dart';
import '../widgets/expense_day_group.dart';
import '../widgets/month_selector.dart';
import 'add_expense_page.dart';
import 'budget_goals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorageService _storage = LocalStorageService();

  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category in ExpenseCategory.values) category: 0.0,
  };

  bool _isLoading = true;

  // O mês selecionado é guardado como o dia 1 daquele mês.
  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool get _isCurrentMonth {
    return DateFormatter.isSameMonth(_selectedMonth, DateTime.now());
  }

  // Apenas os gastos do mês selecionado, do mais recente para o mais antigo.
  List<Expense> get _monthExpenses {
    final expenses = _expenses
        .where(
          (expense) => DateFormatter.isSameMonth(expense.date, _selectedMonth),
        )
        .toList();

    expenses.sort((a, b) {
      final byDate = b.date.compareTo(a.date);

      if (byDate != 0) {
        return byDate;
      }

      // Mesmo dia: o cadastrado por último aparece primeiro.
      return b.id.compareTo(a.id);
    });

    return expenses;
  }

  // Agrupa os gastos do mês por dia.
  Map<DateTime, List<Expense>> get _expensesByDay {
    final groups = <DateTime, List<Expense>>{};

    for (final expense in _monthExpenses) {
      final day = DateFormatter.onlyDate(expense.date);

      groups.putIfAbsent(day, () => []).add(expense);
    }

    return groups;
  }

  double get _totalSpent {
    return _monthExpenses.fold(0.0, (total, expense) => total + expense.amount);
  }

  double get _totalBudget {
    return _goals.values.fold(0.0, (total, goal) => total + goal);
  }

  double spentByCategory(ExpenseCategory category) {
    return _monthExpenses
        .where((expense) => expense.category == category)
        .fold(0.0, (total, expense) => total + expense.amount);
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    if (_isCurrentMonth) {
      return;
    }

    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    final expenses = await _storage.loadExpenses();
    final goals = await _storage.loadGoals();

    if (!mounted) {
      return;
    }

    setState(() {
      _expenses
        ..clear()
        ..addAll(expenses);

      _goals
        ..clear()
        ..addAll(goals);

      _isLoading = false;
    });
  }

  Future<void> _openAddExpense() async {
    final expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );

    if (expense == null || !mounted) {
      return;
    }

    setState(() {
      _expenses.add(expense);

      // Mostra o mês do gasto que acabou de ser cadastrado.
      _selectedMonth = DateTime(expense.date.year, expense.date.month);
    });

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _editExpense(Expense expense) async {
    final updatedExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpensePage(expenseToEdit: expense),
      ),
    );

    if (updatedExpense == null || !mounted) {
      return;
    }

    final index = _expenses.indexWhere((item) => item.id == updatedExpense.id);

    if (index == -1) {
      return;
    }

    setState(() {
      _expenses[index] = updatedExpense;

      // Se a data mudou de mês, acompanha o gasto.
      _selectedMonth = DateTime(
        updatedExpense.date.year,
        updatedExpense.date.month,
      );
    });

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _deleteExpense(Expense expense) async {
    final shouldDelete =
        await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Delete Expense🗑'),
              content: Text(
                'Do You really want delete this?🗑 "${expense.title}"?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel🚫'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Delete🗑'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!shouldDelete || !mounted) {
      return;
    }

    setState(() {
      _expenses.removeWhere((item) => item.id == expense.id);
    });

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _openBudgetGoals() async {
    final goals = await Navigator.push<Map<ExpenseCategory, double>>(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetGoalsPage(currentGoals: Map.of(_goals)),
      ),
    );

    if (goals == null || !mounted) {
      return;
    }

    setState(() {
      _goals
        ..clear()
        ..addAll(goals);
    });

    await _storage.saveGoals(_goals);
  }

  @override
  Widget build(BuildContext context) {
    final expensesByDay = _expensesByDay;

    return Scaffold(
      appBar: AppBar(
        title: const Text('📈Monthly Budget'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: '✎Edit Goals',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MonthSelector(
                      selectedMonth: _selectedMonth,
                      onPrevious: _goToPreviousMonth,
                      onNext: _isCurrentMonth ? null : _goToNextMonth,
                    ),
                    const SizedBox(height: 16),
                    BudgetSummaryCard(budget: _totalBudget, spent: _totalSpent),
                    const SizedBox(height: 24),
                    const Text(
                      '📌Goals by Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...ExpenseCategory.values.map(
                      (category) => CategoryBudgetCard(
                        category: category,
                        goal: _goals[category] ?? 0,
                        spent: spentByCategory(category),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '📋Transaction History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (expensesByDay.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('💵No expenses this month.'),
                        ),
                      )
                    else
                      ...expensesByDay.entries.map(
                        (entry) => ExpenseDayGroup(
                          day: entry.key,
                          expenses: entry.value,
                          onEdit: (expense) {
                            _editExpense(expense);
                          },
                          onDelete: (expense) {
                            _deleteExpense(expense);
                          },
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _openAddExpense,
              child: const Icon(Icons.add),
            ),
    );
  }
}
