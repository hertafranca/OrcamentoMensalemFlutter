import 'package:flutter/material.dart';

import '../models/expense_category.dart';
// Tela para definir os objetivos de gastos mensais por categoria.
class BudgetGoalsPage extends StatefulWidget {
  final Map<ExpenseCategory, double> currentGoals;

  const BudgetGoalsPage({super.key, required this.currentGoals});

  @override
  State<BudgetGoalsPage> createState() => _BudgetGoalsPageState();
}
// Estado da tela de objetivos de gastos mensais.
class _BudgetGoalsPageState extends State<BudgetGoalsPage> {
  final _formKey = GlobalKey<FormState>();

  late final Map<ExpenseCategory, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = {
      for (final category in ExpenseCategory.values)
        category: TextEditingController(
          text: (widget.currentGoals[category] ?? 0).toStringAsFixed(2),
        ),
    };
  }

  // Soma o que está digitado nos campos neste momento.
  double get _totalGoals {
    double total = 0;

    for (final controller in _controllers.values) {
      final value = double.tryParse(controller.text.replaceAll(',', '.'));

      if (value != null && value > 0) {
        total += value;
      }
    }

    return total;
  }
// Formata o valor monetário para exibição.
  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  void _saveGoals() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final goals = <ExpenseCategory, double>{};

    for (final category in ExpenseCategory.values) {
      final text = _controllers[category]!.text.replaceAll(',', '.');

      goals[category] = double.parse(text);
    }

    Navigator.pop(context, goals);
  }
// Libera os controladores de texto quando a tela é descartada.
  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }
// Constrói a interface da tela de objetivos de gastos mensais.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Goals')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Define how much you want to spend by month in each category.',
                ),
                // Espaço entre o texto explicativo e os campos de entrada.
                const SizedBox(height: 8),
                const Text(
                  'These goals apply to all months. '
                  'Consumption is calculated separately for each month.',
                ),
                // Espaço entre o texto explicativo e os campos de entrada.
                const SizedBox(height: 24),
                ...ExpenseCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: _controllers[category],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      // Espaço entre o campo de entrada e o rótulo.
                      decoration: InputDecoration(
                        labelText: category.label,
                        prefixText: '€ ',
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (_) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Inform a goal.';
                        }
// Valida se o valor digitado é um número válido e não negativo.
                        final goal = double.tryParse(
                          value.replaceAll(',', '.'),
                        );

                        if (goal == null) {
                          return 'Informe um valor válido.';
                        }

                        if (goal < 0) {
                          return 'The goal must be negative.';
                        }
// Retorna null se a validação for bem-sucedida.
                        return null;
                      },
                    ),
                  );
                }),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Monthly Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // Espaço entre o texto e o valor total.
                        ),
                        // Exibe o valor total formatado.
                        Text(
                          _formatMoney(_totalGoals),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        // Espaço entre o valor total e o ícone de informação.
                      ],
                    ),
                    // Espaço entre o valor total e o ícone de informação.
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveGoals,
                  child: const Text('Goals Salve'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// A tela de objetivos de gastos mensais permite que o 
//usuário defina metas de gastos para cada categoria de despesa.
// Ela utiliza um formulário para validar os valores inseridos e 
//calcula o total mensal com base nos valores fornecidos. 
//Ao salvar, os objetivos são retornados para a tela anterior.