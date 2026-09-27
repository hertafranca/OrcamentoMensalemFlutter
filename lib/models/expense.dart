import 'expense_category.dart';

class Expense {
  final String id;
  final String title;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;

  const Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  Expense copyWith({
    String? id,
    String? title,
    ExpenseCategory? category,
    double? amount,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final dateText = json['date'] as String?;

    // Gastos da Fase 2 não têm data salva.
    // Nesse caso, usamos o momento em que o gasto foi criado (guardado no id).
    final date = dateText == null
        ? _dateFromId(id)
        : DateTime.tryParse(dateText) ?? _dateFromId(id);

    return Expense(
      id: id,
      title: json['title'] as String,
      category: ExpenseCategory.fromName(json['category'] as String),
      amount: (json['amount'] as num).toDouble(),
      date: DateTime(date.year, date.month, date.day),
    );
  }

  static DateTime _dateFromId(String id) {
    final microseconds = int.tryParse(id);

    if (microseconds == null) {
      return DateTime.now();
    }

    return DateTime.fromMicrosecondsSinceEpoch(microseconds);
  }
}
