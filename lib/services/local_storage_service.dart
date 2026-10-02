// lib/services/local_storage_service.dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';

// Importar bibliotecas e arquivos necessários para o serviço de 
//armazenamento local.
class LocalStorageService {
  static const String _expensesKey = 'expenses';
  static const String _goalsKey = 'goals';
//
  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Map<ExpenseCategory, double> _emptyGoals() {
    return {for (final category in ExpenseCategory.values) category: 0.0};
  }
// Salvar e carregar despesas e metas de gastos usando SharedPreferences.

  Future<void> saveExpenses(List<Expense> expenses) async {
    final expensesAsJson = expenses.map((expense) => expense.toJson()).toList();

    final encodedExpenses = jsonEncode(expensesAsJson);

    await _preferences.setString(_expensesKey, encodedExpenses);
  }
// Carregar despesas salvas do armazenamento local.
  Future<List<Expense>> loadExpenses() async {
    final encodedExpenses = await _preferences.getString(_expensesKey);

    if (encodedExpenses == null || encodedExpenses.isEmpty) {
      return [];
    }
// Decodificar as despesas salvas e convertê-las em objetos Expense.
    try {
      final decodedExpenses = jsonDecode(encodedExpenses) as List<dynamic>;

      return decodedExpenses.map((item) {
        final map = Map<String, dynamic>.from(item as Map);
// Converter cada item do JSON em um objeto Expense.
        return Expense.fromJson(map);
      }).toList();
    } catch (_) {
      return [];
    }
  }
// Salvar e carregar metas de gastos por categoria.
  Future<void> saveGoals(Map<ExpenseCategory, double> goals) async {
    final goalsAsJson = {
      for (final category in ExpenseCategory.values)
        category.name: goals[category] ?? 0.0,
    };

    final encodedGoals = jsonEncode(goalsAsJson);

    await _preferences.setString(_goalsKey, encodedGoals);
  }
// Carregar metas de gastos salvas do armazenamento local.
  Future<Map<ExpenseCategory, double>> loadGoals() async {
    final encodedGoals = await _preferences.getString(_goalsKey);

    if (encodedGoals == null || encodedGoals.isEmpty) {
      return _emptyGoals();
    }
// Decodificar as metas de gastos salvas e convertê-las em um mapa de
//ExpenseCategory para double.
    try {
      final decodedGoals = Map<String, dynamic>.from(
        jsonDecode(encodedGoals) as Map,
      );
// Criar um mapa de metas de gastos com categorias e valores.
      final goals = _emptyGoals();

      for (final entry in decodedGoals.entries) {
        final category = ExpenseCategory.fromName(entry.key);
        final value = (entry.value as num?)?.toDouble() ?? 0.0;

        goals[category] = value;
      }
// Retornar o mapa de metas de gastos carregado.
      return goals;
    } catch (_) {
      return _emptyGoals();
    }
  }
}
