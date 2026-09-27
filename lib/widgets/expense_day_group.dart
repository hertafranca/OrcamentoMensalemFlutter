import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/date_formatter.dart';
import 'expense_tile.dart';

class ExpenseDayGroup extends StatelessWidget {
  final DateTime day;
  final List<Expense> expenses;
  final void Function(Expense expense) onEdit;
  final void Function(Expense expense) onDelete;

  const ExpenseDayGroup({
    super.key,
    required this.day,
    required this.expenses,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final dayTotal = expenses.fold(
      0.0,
      (total, expense) => total + expense.amount,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormatter.dayTitle(day),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                _formatMoney(dayTotal),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        ...expenses.map(
          (expense) => ExpenseTile(
            expense: expense,
            onEdit: () {
              onEdit(expense);
            },
            onDelete: () {
              onDelete(expense);
            },
          ),
        ),
      ],
    );
  }
}
