import 'package:flutter/material.dart';
import 'package:orcamento2026/models/expense.dart';
import 'package:orcamento2026/models/expense_category.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const BudgetApp());
}
// Classe principal do aplicativo, que define o tema e a página inicial.
class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});
// Construtor do widget BudgetApp, que recebe uma chave opcional como parâmetro.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Montly Expense',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Define a página inicial do aplicativo como HomePage.
      home: const HomePage(),
    );
    // Retorna um widget MaterialApp com as configurações de tema 
    //e a página inicial.
  }
}
