import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../services/local_storage_service.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_budget_card.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_page.dart';
import 'budget_goals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorageService _storage =
      LocalStorageService();

  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category
        in ExpenseCategory.values)
      category: 0.0,
  };

  bool _isLoading = true;

  double get _totalSpent {
    return _expenses.fold(
      0,
      (total, expense) =>
          total + expense.amount,
    );
  }

  double get _totalBudget {
    return _goals.values.fold(
      0,
      (total, goal) => total + goal,
    );
  }

  double spentByCategory(
    ExpenseCategory category,
  ) {
    return _expenses
        .where(
          (expense) =>
              expense.category == category,
        )
        .fold(
          0,
          (total, expense) =>
              total + expense.amount,
        );
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    final expenses =
        await _storage.loadExpenses();

    final goals =
        await _storage.loadGoals();

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
    final expense =
        await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddExpensePage(),
      ),
    );

    if (expense == null || !mounted) {
      return;
    }

    setState(() {
      _expenses.add(expense);
    });

    await _storage.saveExpenses(
      _expenses,
    );
  }

  Future<void> _editExpense(
    Expense expense,
  ) async {
    final updatedExpense =
        await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddExpensePage(
          expenseToEdit: expense,
        ),
      ),
    );

    if (updatedExpense == null ||
        !mounted) {
      return;
    }

    final index = _expenses.indexWhere(
      (item) =>
          item.id == updatedExpense.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _expenses[index] = updatedExpense;
    });

    await _storage.saveExpenses(
      _expenses,
    );
  }

  Future<void> _deleteExpense(
    Expense expense,
  ) async {
    final shouldDelete =
        await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Delete Expense',
                  ),
                  content: Text(
                    'Do you really want to delete? "${expense.title}"?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          false,
                        );
                      },
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          true,
                        );
                      },
                      child: const Text(
                        'Delete',
                      ),
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
      _expenses.removeWhere(
        (item) =>
            item.id == expense.id,
      );
    });

    await _storage.saveExpenses(
      _expenses,
    );
  }

  Future<void> _openBudgetGoals() async {
    final goals =
        await Navigator.push<
            Map<ExpenseCategory, double>
        >(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BudgetGoalsPage(
          currentGoals: Map.of(_goals),
        ),
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
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Monthly Budget'),
        actions: [
          IconButton(
            onPressed: _isLoading
                ? null
                : _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: 'Edit Goals',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    BudgetSummaryCard(
                      budget: _totalBudget,
                      spent: _totalSpent,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Goals by Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ...ExpenseCategory.values
                        .map(
                      (category) =>
                          CategoryBudgetCard(
                        category: category,
                        goal:
                            _goals[category] ??
                                0,
                        spent:
                            spentByCategory(
                          category,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Transactions Historic',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (_expenses.isEmpty)
                      const Card(
                        child: Padding(
                          padding:
                              EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'No transactions registered.',
                          ),
                        ),
                      )
                    else
                      ..._expenses.map(
                        (expense) =>
                            ExpenseTile(
                          expense: expense,
                          onEdit: () {
                            _editExpense(
                              expense,
                            );
                          },
                          onDelete: () {
                            _deleteExpense(
                              expense,
                            );
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _openAddExpense,
              child:
                  const Icon(Icons.add),
            ),
    );
  }
}
