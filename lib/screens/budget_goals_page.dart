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
      appBar: AppBar(title: const Text('Goals for the month')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Inform how much you intend to spend in each category.',
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'State a goal.';
                        }

                        final goal = double.tryParse(
                          value.replaceAll(',', '.'),
                        );

                        if (goal == null) {
                          return 'Inform a valid value.';
                        }

                        if (goal < 0) {
                          return 'A meta não pode ser negativa';
                        }

                        return null;
                      },
                    ),
                  );
                }),
                ElevatedButton(
                  onPressed: _saveGoals,
                  child: const Text('Save Goals'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
