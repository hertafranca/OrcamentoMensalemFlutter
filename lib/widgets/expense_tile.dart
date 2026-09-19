import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;

  const ExpenseTile({super.key, required this.expense});

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(expense.title),
        subtitle: Text(expense.category.label),
        trailing: Text(
          _formatMoney(expense.amount),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
