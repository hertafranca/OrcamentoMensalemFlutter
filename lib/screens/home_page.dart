import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
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

  double get _balance {
    return _totalBudget - _totalSpent;
  }

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
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
    final isOverBudget = _balance < 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento Mensal'),
        actions: [
          IconButton(
            onPressed: _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: 'Definir metas',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumo do mês',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Orçamento: ${_formatMoney(_totalBudget)}'),
                      const SizedBox(height: 8),
                      Text('Gasto: ${_formatMoney(_totalSpent)}'),
                      const SizedBox(height: 8),
                      if (isOverBudget)
                        Text('Excedido: ${_formatMoney(_balance.abs())}')
                      else
                        Text('Restante: ${_formatMoney(_balance)}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Histórico de transações',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (_expenses.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nenhuma transação cadastrada.'),
                  ),
                )
              else
                ..._expenses.map((expense) => ExpenseTile(expense: expense)),
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
