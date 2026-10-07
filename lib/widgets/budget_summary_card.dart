import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/money_formatter.dart';

class BudgetSummaryCard extends StatelessWidget {
  final double budget;
  final double spent;

  const BudgetSummaryCard({
    super.key,
    required this.budget,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final hasBudget = budget > 0;
    final balance = budget - spent;
    final isOverBudget = hasBudget && balance < 0;
    final ratio = hasBudget ? spent / budget : 0.0;
    //ignore: unused_local_variable
    //final percent = (ratio * 100).round();

    final String label;
    final double mainValue;
    final Color mainColor;
    final IconData statusIcon;
    final Color statusColor;
    final String statusText;

    if (!hasBudget) {
      label = 'Monthly Budget';
      mainValue = spent;
      mainColor = AppColors.textPrimary;
      statusIcon = Icons.info_outline_rounded;
      statusColor = AppColors.textSecondary;
      statusText = 'Set your goals to track the budget.';
    } else if (isOverBudget) {
      label = 'Over Budget';
      mainValue = balance.abs();
      mainColor = AppColors.danger;
      statusIcon = Icons.warning_amber_rounded;
      statusColor = AppColors.danger;
      statusText = 'You have exceeded this month budget.';
    } else if (ratio >= 0.8) {
      label = 'Available to spend';
      mainValue = balance;
      mainColor = AppColors.richGold;
      statusIcon = Icons.error_outline_rounded;
      statusColor = AppColors.warning;
      statusText = 'You are close to exceeding your budget.';
    } else {
      label = 'Available to spend';
      mainValue = balance;
      mainColor = AppColors.richGold;
      statusIcon = Icons.check_circle_outline_rounded;
      statusColor = AppColors.success;
      statusText = 'You are on track with your budget.';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.bottleGreen, AppColors.imperialPurple],
        ),
        border: Border.all(color: AppColors.richGold.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              MoneyFormatter.format(mainValue),
              style: textTheme.displaySmall?.copyWith(
                color: mainColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (hasBudget) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0).toDouble(),
                minHeight: 8,
                color: statusColor,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: _SummaryValue(label: 'Expense', value: spent),
              ),
              Expanded(
                child: _SummaryValue(
                  label: 'Budget',
                  value: budget,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 20),
                const SizedBox(width: 8),
                Expanded(child: Text(statusText, style: textTheme.bodyMedium)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final String label;
  final double value;
  final bool alignEnd;

  const _SummaryValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 2),
        Text(
          MoneyFormatter.format(value),
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
