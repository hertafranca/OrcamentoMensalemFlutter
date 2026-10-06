import 'package:flutter/material.dart';

import '../models/expense_category.dart';

extension ExpenseCategoryIcon on ExpenseCategory {
  IconData get icon {
    return switch (this) {
      ExpenseCategory.food => Icons.restaurant_rounded,
      ExpenseCategory.transport => Icons.directions_car_rounded,
      ExpenseCategory.leisure => Icons.local_activity_rounded,
      ExpenseCategory.shopping => Icons.shopping_bag_rounded,
      ExpenseCategory.home => Icons.home_rounded,
      ExpenseCategory.education => Icons.school_rounded,
      ExpenseCategory.other => Icons.more_horiz_rounded,
    };
  }
}
