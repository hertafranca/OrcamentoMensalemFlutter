import 'expense_category.dart';

class Expense {
  final String title;
  final ExpenseCategory category;
  final double amount;

  const Expense({
    required this.title,
    required this.category,
    required this.amount,
  });
}
