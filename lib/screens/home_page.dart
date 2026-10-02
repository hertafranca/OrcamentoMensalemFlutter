// lib/screens/home_page.dart
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
// A tela principal do aplicativo de orçamento mensal.
class _HomePageState extends State<HomePage> {
  final LocalStorageService _storage = LocalStorageService();

  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category in ExpenseCategory.values) category: 0.0,
  };
// Indica se os dados estão sendo carregados do armazenamento local.
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
// Ordena os gastos do mês selecionado do mais recente para o mais antigo.
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
// Calcula o total gasto no mês selecionado.
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
// Navega para o mês anterior.
  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
    });
  }

  void _goToNextMonth() {
    if (_isCurrentMonth) {
      return;
    }
// Navega para o próximo mês, se não for o mês atual.
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }
// Carrega os gastos e objetivos salvos do armazenamento local.
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
// Abre a tela para adicionar um novo gasto.
  Future<void> _openAddExpense() async {
    final expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );

    if (expense == null || !mounted) {
      return;
    }
// Adiciona o novo gasto à lista e salva no armazenamento local.
    setState(() {
      _expenses.add(expense);

      // Mostra o mês do gasto que acabou de ser cadastrado.
      _selectedMonth = DateTime(expense.date.year, expense.date.month);
    });

    await _storage.saveExpenses(_expenses);
  }
// Abre a tela para editar um gasto existente.
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
// Encontra o índice do gasto atualizado na lista e atualiza os dados.
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
//  Exibe um diálogo de confirmação antes de excluir um gasto.
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
// Se o usuário não confirmou a exclusão ou a tela não está mais montada, retorna sem fazer nada.
    if (!shouldDelete || !mounted) {
      return;
    }

    setState(() {
      _expenses.removeWhere((item) => item.id == expense.id);
    });

    await _storage.saveExpenses(_expenses);
  }
// Abre a tela de objetivos de gastos mensais para edição.
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
// Atualiza os objetivos de gastos e salva no armazenamento local.
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
// Constrói a interface da tela principal do aplicativo de orçamento mensal.
    return Scaffold(
      appBar: AppBar(
        title: const Text('📈Monthly Budget'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: '✎Edit Goals',
          ),
          // Espaço entre o botão de edição de objetivos e a borda da tela.
        ],
      ),
      // Espaço entre a barra de aplicativos e o conteúdo da tela.
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
                    ),//  Espaço entre o seletor de mês e o resumo do orçamento.
                    const SizedBox(height: 16),
                    BudgetSummaryCard(budget: _totalBudget, spent: _totalSpent),
                    const SizedBox(height: 24),
                    const Text(
                      '📌Goals by Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),// Espaço entre o título e os cartões de categoria. 
                    ),
                    const SizedBox(height: 8),
                    ...ExpenseCategory.values.map(
                      (category) => CategoryBudgetCard(
                        category: category,
                        goal: _goals[category] ?? 0,
                        spent: spentByCategory(category),
                      ),// Espaço entre os cartões de categoria.
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      '📋Transaction History',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      // Espaço entre o título e a lista de gastos.
                    ),
                    const SizedBox(height: 8),
                    if (expensesByDay.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('💵No expenses this month.'),
                        ),
                        // Espaço entre a mensagem de ausência de gastos e 
                        //a borda da tela.
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
                        // Espaço entre os grupos de gastos por dia.  
                      ),
                    const SizedBox(height: 80),
                  ],
                ),// Espaço entre o conteúdo da tela e a borda inferior da tela.
              ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _openAddExpense,
              child: const Icon(Icons.add),
            ),// Espaço entre o botão flutuante e a borda inferior da tela.
    );// Espaço entre o botão flutuante e a borda inferior da tela.
  }
}
