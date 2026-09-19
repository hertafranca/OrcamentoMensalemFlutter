import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_budget_card.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_page.dart';
import 'budget_goals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category in ExpenseCategory.values) category: 0.0,
  };

  double get _totalSpent {
    return _expenses.fold(0, (total, expense) => total + expense.amount);
  }

  double get _totalBudget {
    return _goals.values.fold(0, (total, goal) => total + goal);
  }

  double spentByCategory(ExpenseCategory category) {
    return _expenses
        .where((expense) => expense.category == category)
        .fold(0, (total, expense) => total + expense.amount);
  }

  Future<void> _openAddExpense() async {
    final expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );

    if (expense == null) {
      return;
    }

    setState(() {
      _expenses.add(expense);
    });
  }

  Future<void> _openBudgetGoals() async {
    final goals = await Navigator.push<Map<ExpenseCategory, double>>(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetGoalsPage(currentGoals: Map.of(_goals)),
      ),
    );

    if (goals == null) {
      return;
    }

    setState(() {
      _goals
        ..clear()
        ..addAll(goals);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mounthly Expense'),
        actions: [
          IconButton(
            onPressed: _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: 'Set Goals',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BudgetSummaryCard(budget: _totalBudget, spent: _totalSpent),
              const SizedBox(height: 24),
              const Text(
                'Goals by category',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                'Transaction history',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_expenses.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No transactions registered.'),
                  ),
                )
              else
                ..._expenses.map((expense) => ExpenseTile(expense: expense)),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
