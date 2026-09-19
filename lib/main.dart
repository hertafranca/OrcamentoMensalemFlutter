import 'package:flutter/material.dart';
import 'package:orcamento2026/models/expense.dart';
import 'package:orcamento2026/models/expense_category.dart';

import 'screens/home_page.dart';

void main() {
  //print(ExpenseCategory.restaurant.label);
  final expense = Expense(
    title: 'Brasao´s Dinner',
    category: ExpenseCategory.restaurant,
    amount: 35.50,
  );
  //print(expense.title);
  // print(expense.category.label);
  // print(expense.amount);

  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Montly Expense',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
