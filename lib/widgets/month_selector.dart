import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onCurrentMonth;

  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
    this.onCurrentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left_rounded),
              tooltip: 'Before Month',
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Selected Month',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormatter.monthAndYear(selectedMonth),
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right_rounded),
              tooltip: 'Next Month',
            ),
          ],
        ),
        if (onCurrentMonth != null)
          TextButton.icon(
            onPressed: onCurrentMonth,
            icon: const Icon(Icons.today_rounded, size: 18),
            label: const Text('Return to the current month'),
          ),
      ],
    );
  }
}
