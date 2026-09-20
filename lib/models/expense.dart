import 'expense_category.dart';

class Expense {
  final String id;
  final String title;
  final ExpenseCategory category;
  final double amount;

  const Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
  });

  Expense copyWith({
    String? id,
    String? title,
    ExpenseCategory? category,
    double? amount,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'amount': amount,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    final categoryName = json['category'] as String;

    final category = ExpenseCategory.values.firstWhere(
      (category) => category.name == categoryName,
      orElse: () => ExpenseCategory.restaurant,
    );

    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      category: category,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
