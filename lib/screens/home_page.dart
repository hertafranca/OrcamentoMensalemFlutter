import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _expenses = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mounthly Expense')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _expenses.isEmpty
              ? const Center(child: Text('No transactions registered.'))
              : ListView.builder(
                  itemCount: _expenses.length,
                  itemBuilder: (context, index) {
                    final expense = _expenses[index];

                    return ExpenseTile(expense: expense);
                  },
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
