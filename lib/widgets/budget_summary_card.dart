import 'package:flutter/material.dart';

class BudgetSummaryCard extends StatelessWidget {
  final double budget;
  final double spent;

  const BudgetSummaryCard({
    super.key,
    required this.budget,
    required this.spent,
  });

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final balance = budget - spent;
    final isOverBudget = balance < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Summary of the month',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text('Budget: ${_formatMoney(budget)}'),
            const SizedBox(height: 8),
            Text('Expense: ${_formatMoney(spent)}'),
            const SizedBox(height: 8),
            if (isOverBudget)
              Text(
                'Exceeded: ${_formatMoney(balance.abs())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            else
              Text(
                'Remaining: ${_formatMoney(balance)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),
            if (budget == 0 && spent == 0)
              const Text('Define your monthly goals to get started.')
            else if (isOverBudget)
              const Text('Budget exceeded.')
            else
              const Text('You are within budget.'),
          ],
        ),
      ),
    );
  }
}
