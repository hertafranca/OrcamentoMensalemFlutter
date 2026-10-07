import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import '../utils/money_formatter.dart';
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final dayTotal = expenses.fold(
      0.0,
      (total, expense) => total + expense.amount,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormatter.dayTitle(day).toUpperCase(),
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.richGold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Text(
                MoneyFormatter.format(dayTotal),
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ...expenses.map(
          (expense) => ExpenseTile(
            key: ValueKey(expense.id),
            expense: expense,
            onTap: () {
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
