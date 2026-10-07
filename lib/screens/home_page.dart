import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../services/local_storage_service.dart';
import '../utils/date_formatter.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_budget_card.dart';
import '../widgets/empty_state.dart';
import '../widgets/expense_day_group.dart';
import '../widgets/month_selector.dart';
import '../widgets/section_title.dart';
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

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);

  bool get _isCurrentMonth {
    return DateFormatter.isSameMonth(_selectedMonth, DateTime.now());
  }

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

      return b.id.compareTo(a.id);
    });

    return expenses;
  }

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

  void _goToCurrentMonth() {
    final now = DateTime.now();

    setState(() {
      _selectedMonth = DateTime(now.year, now.month);
    });
  }

  // Mostra uma mensagem curta na parte de baixo da tela.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
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

      _selectedMonth = DateTime(expense.date.year, expense.date.month);
    });

    _showMessage('Added Expenses.');

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

      _selectedMonth = DateTime(
        updatedExpense.date.year,
        updatedExpense.date.month,
      );
    });

    _showMessage('Changes saved.');

    await _storage.saveExpenses(_expenses);
  }

  // Chamado quando o gasto é deslizado para fora da tela.
  // Remove na hora (o Dismissible exige isso) e oferece "Desfazer".
  Future<void> _deleteExpense(Expense expense) async {
    final index = _expenses.indexWhere((item) => item.id == expense.id);

    if (index == -1) {
      return;
    }

    setState(() {
      _expenses.removeAt(index);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${expense.title}"It was excluded.'),
          showCloseIcon: true,
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () {
              _undoDelete(expense, index);
            },
          ),
        ),
      );

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _undoDelete(Expense expense, int index) async {
    if (!mounted) {
      return;
    }

    setState(() {
      final safeIndex = index.clamp(0, _expenses.length).toInt();

      _expenses.insert(safeIndex, expense);

      _selectedMonth = DateTime(expense.date.year, expense.date.month);
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

    _showMessage('Updated goals.');

    await _storage.saveGoals(_goals);
  }

  @override
  Widget build(BuildContext context) {
    final expensesByDay = _expensesByDay;

    // Só mostra categorias com meta ou com gasto no mês.
    final visibleCategories = ExpenseCategory.values
        .where(
          (category) =>
              (_goals[category] ?? 0) > 0 || spentByCategory(category) > 0,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Budget'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _openBudgetGoals,
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Monthly Goals',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                children: [
                  MonthSelector(
                    selectedMonth: _selectedMonth,
                    onPrevious: _goToPreviousMonth,
                    onNext: _isCurrentMonth ? null : _goToNextMonth,
                    onCurrentMonth: _isCurrentMonth ? null : _goToCurrentMonth,
                  ),
                  const SizedBox(height: 16),
                  BudgetSummaryCard(budget: _totalBudget, spent: _totalSpent),
                  const SectionTitle(
                    title: 'Goals by category',
                    subtitle:
                        'Consumption for each target in the selected month.',
                  ),
                  if (_totalBudget == 0)
                    EmptyState(
                      icon: Icons.flag_rounded,
                      title: 'Define your goals.',
                      message: 'Choose how much you want to spend per month in each category.',
                      actionLabel: 'Set goals',
                      onAction: _openBudgetGoals,
                    ),
                  ...visibleCategories.map(
                    (category) => CategoryBudgetCard(
                      category: category,
                      goal: _goals[category] ?? 0,
                      spent: spentByCategory(category),
                    ),
                  ),
                  SectionTitle(
                    title: 'Historical',
                    subtitle: expensesByDay.isEmpty
                        ? null
                        : 'Tap to edit • scroll left to delete',
                  ),
                  if (expensesByDay.isEmpty)
                    const EmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: 'No expenses this month.',
                      message: 'Tap "New expense" to register the first one.',
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
                ],
              ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: _openAddExpense,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Expense'),
            ),
    );
  }
}
