import 'package:flutter/material.dart';

import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../theme/category_icons.dart';

class CategoryAvatar extends StatelessWidget {
  final ExpenseCategory category;
  final double size;

  const CategoryAvatar({super.key, required this.category, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.richGold.withValues(alpha: 0.4)),
      ),
      child: Icon(category.icon, color: AppColors.richGold, size: size * 0.5),
    );
  }
}
