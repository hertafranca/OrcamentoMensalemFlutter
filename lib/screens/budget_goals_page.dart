import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/category_icons.dart';
import '../utils/money_formatter.dart';

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
          text: _textFromValue(widget.currentGoals[category] ?? 0),
        ),
    };
  }

  // 0     → campo vazio
  // 300.5 → "300,50"
  static String _textFromValue(double value) {
    if (value == 0) {
      return '';
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  // Campo vazio → 0
  double _valueFromController(TextEditingController controller) {
    final text = controller.text.trim().replaceAll(',', '.');

    if (text.isEmpty) {
      return 0;
    }

    return double.tryParse(text) ?? 0;
  }

  double get _totalGoals {
    double total = 0;

    for (final controller in _controllers.values) {
      total += _valueFromController(controller);
    }

    return total;
  }

  void _saveGoals() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final goals = <ExpenseCategory, double>{};

    for (final category in ExpenseCategory.values) {
      goals[category] = _valueFromController(_controllers[category]!);
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Goal')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'How much do you plan to spend per month in each category?',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'The goals apply to all months. '
                'Leave the categories without a goal blank.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ...ExpenseCategory.values.map((category) {
                final isLast = category == ExpenseCategory.values.last;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextFormField(
                    controller: _controllers[category],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    textInputAction: isLast
                        ? TextInputAction.done
                        : TextInputAction.next,
                    decoration: AppTheme.input(
                      label: category.label,
                      hintText: '0,00',
                      prefixText: '€ ',
                      prefixIcon: Icon(
                        category.icon,
                        color: AppColors.richGold,
                      ),
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    validator: (value) {
                      final text = (value ?? '').trim();

                      if (text.isEmpty) {
                        return null;
                      }

                      final goal = double.tryParse(text.replaceAll(',', '.'));

                      if (goal == null) {
                        return 'Please provide a valid value.';
                      }

                      if (goal < 0) {
                        return 'The goal cannot be negative.';
                      }

                      return null;
                    },
                  ),
                );
              }),
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Monthly total',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        MoneyFormatter.format(_totalGoals),
                        style: textTheme.headlineSmall?.copyWith(
                          color: AppColors.richGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _saveGoals,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Save goals'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
