import 'package:flutter/material.dart';

import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../utils/money_formatter.dart';
import 'category_avatar.dart';

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final hasGoal = goal > 0;
    final ratio = hasGoal ? spent / goal : 0.0;
    final difference = goal - spent;

    final Color statusColor;
    final String statusText;

    if (!hasGoal) {
      statusColor = AppColors.textSecondary;
      statusText = 'No defined goal.';
    } else if (ratio > 1) {
      statusColor = AppColors.danger;
      statusText = 'Exceeded amount ${MoneyFormatter.format(difference.abs())}';
    } else if (ratio >= 0.8) {
      statusColor = AppColors.warning;
      statusText = 'Remaining amount ${MoneyFormatter.format(difference)}';
    } else {
      statusColor = AppColors.success;
      statusText = 'Remaining amount ${MoneyFormatter.format(difference)}';
    }

    final percentText = hasGoal ? '${(ratio * 100).round()}%' : '—';

    final amountText = hasGoal
        ? '${MoneyFormatter.format(spent)} de ${MoneyFormatter.format(goal)}'
        : MoneyFormatter.format(spent);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CategoryAvatar(category: category, size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.label,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        amountText,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  percentText,
                  style: textTheme.titleMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: hasGoal ? ratio.clamp(0.0, 1.0).toDouble() : 0.0,
                minHeight: 6,
                color: statusColor,
                backgroundColor: AppColors.surfaceHigh,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statusText,
              style: textTheme.bodySmall?.copyWith(color: statusColor),
            ),
          ],
        ),
      ),
    );
  }
}
