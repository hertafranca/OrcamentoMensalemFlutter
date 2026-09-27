import 'package:flutter/material.dart';

import '../models/expense_category.dart';

class BudgetGoalsPage extends StatefulWidget {
  final Map<ExpenseCategory, double> currentGoals;

  const BudgetGoalsPage({super.key, required this.currentGoals});

  @override
  State<BudgetGoalsPage> createState() => _BudgetGoalsPageState();
}

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

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

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
                const SizedBox(height: 8),
                const Text(
                  'These goals apply to all months. '
                  'Consumption is calculated separately for each month.',
                ),
                const SizedBox(height: 24),
                ...ExpenseCategory.values.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: TextFormField(
                      controller: _controllers[category],
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
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

                        final goal = double.tryParse(
                          value.replaceAll(',', '.'),
                        );

                        if (goal == null) {
                          return 'Informe um valor válido.';
                        }

                        if (goal < 0) {
                          return 'The goal must be negative.';
                        }

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
                        ),
                        Text(
                          _formatMoney(_totalGoals),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
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
