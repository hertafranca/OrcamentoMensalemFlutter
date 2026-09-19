import 'package:flutter/material.dart';

import '../models/expense_category.dart';

class CategoryBudgetCard extends StatelessWidget {
  final ExpenseCategory category;
  final double goal;
  final double spent;

  const CategoryBudgetCard({
    super.key,
    required this.category,
    required this.goal,
    required this.spent,
  });

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0 ? (spent / goal).clamp(0.0, 1.0).toDouble() : 0.0;

    final difference = goal - spent;
    final isOverGoal = difference < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              category.label,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${_formatMoney(spent)} de ${_formatMoney(goal)}'),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 8),
            if (goal == 0)
              const Text('Goal not defined.')
            else if (isOverGoal)
              Text('Target exceeded in ${_formatMoney(difference.abs())}.')
            else
              Text('You can still spend ${_formatMoney(difference)}.'),
          ],
        ),
      ),
    );
  }
}
