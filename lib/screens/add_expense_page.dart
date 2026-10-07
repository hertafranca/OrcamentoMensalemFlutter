import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/category_icons.dart';
import '../utils/date_formatter.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? expenseToEdit;

  const AddExpensePage({super.key, this.expenseToEdit});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  ExpenseCategory? _selectedCategory;
  late DateTime _selectedDate;

  // Fica true depois da primeira tentativa de salvar.
  // A partir daí, os erros são atualizados enquanto o usuário digita.
  bool _triedToSave = false;

  bool get _isEditing {
    return widget.expenseToEdit != null;
  }

  @override
  void initState() {
    super.initState();

    final expense = widget.expenseToEdit;

    _titleController = TextEditingController(text: expense?.title ?? '');

    _amountController = TextEditingController(
      text: expense == null
          ? ''
          : expense.amount.toStringAsFixed(2).replaceAll('.', ','),
    );

    _selectedCategory = expense?.category;

    _selectedDate = expense?.date ?? DateFormatter.onlyDate(DateTime.now());
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }

  Future<void> _pickDate() async {
    final today = DateFormatter.onlyDate(DateTime.now());

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today) ? today : _selectedDate,
      firstDate: DateTime(2000),
      lastDate: today,
      helpText: 'Expense Date',
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    _selectDate(DateFormatter.onlyDate(pickedDate));
  }

  void _saveExpense() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      setState(() {
        _triedToSave = true;
      });

      return;
    }

    final amount = double.parse(_amountController.text.replaceAll(',', '.'));

    final existingExpense = widget.expenseToEdit;

    final expense = existingExpense == null
        ? Expense(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            category: _selectedCategory!,
            amount: amount,
            date: _selectedDate,
          )
        : existingExpense.copyWith(
            title: _titleController.text.trim(),
            category: _selectedCategory!,
            amount: amount,
            date: _selectedDate,
          );

    Navigator.pop(context, expense);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final amountStyle = textTheme.displaySmall?.copyWith(
      color: AppColors.richGold,
      fontWeight: FontWeight.w700,
    );

    final sectionStyle = textTheme.labelLarge?.copyWith(
      color: AppColors.textSecondary,
      letterSpacing: 1.2,
    );

    final today = DateFormatter.onlyDate(DateTime.now());
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    final isToday = DateFormatter.isSameDay(_selectedDate, today);
    final isYesterday = DateFormatter.isSameDay(_selectedDate, yesterday);
    final isOtherDate = !isToday && !isYesterday;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Expenses' : 'New Expenses'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: _triedToSave
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text('VALUE', style: sectionStyle),
              TextFormField(
                controller: _amountController,
                autofocus: !_isEditing,
                style: amountStyle,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixText: '€ ',
                  prefixStyle: amountStyle,
                  hintText: '0,00',
                  hintStyle: amountStyle?.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  border: const UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inform the value';
                  }

                  final amount = double.tryParse(value.replaceAll(',', '.'));

                  if (amount == null) {
                    return 'Inform a valid value';
                  }

                  if (amount <= 0) {
                    return 'The value must be greater than zero.';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 28),
              Text('DESCRIPTION', style: sectionStyle),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: AppTheme.input(
                  label: 'Description',
                  hintText: 'Ex.: shopping, Uber, movie',
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Inform a description';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 28),
              Text('CATEGORY', style: sectionStyle),
              const SizedBox(height: 10),
              FormField<ExpenseCategory>(
                initialValue: _selectedCategory,
                validator: (value) {
                  if (value == null) {
                    return 'Select a category';
                  }

                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ExpenseCategory.values.map((category) {
                          return ChoiceChip(
                            avatar: Icon(category.icon, size: 18),
                            label: Text(category.label),
                            selected: field.value == category,
                            showCheckmark: false,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = category;
                              });

                              field.didChange(category);
                            },
                          );
                        }).toList(),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            field.errorText!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Text('DATE', style: sectionStyle),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('TODAY'),
                    selected: isToday,
                    showCheckmark: false,
                    onSelected: (_) {
                      _selectDate(today);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('YESTERDAY'),
                    selected: isYesterday,
                    showCheckmark: false,
                    onSelected: (_) {
                      _selectDate(yesterday);
                    },
                  ),
                  ChoiceChip(
                    avatar: const Icon(Icons.calendar_month_rounded, size: 18),
                    label: Text(
                      isOtherDate
                          ? DateFormatter.fullDate(_selectedDate)
                          : 'Other date',
                    ),
                    selected: isOtherDate,
                    showCheckmark: false,
                    onSelected: (_) {
                      _pickDate();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                onPressed: _saveExpense,
                icon: Icon(
                  _isEditing ? Icons.check_rounded : Icons.add_rounded,
                ),
                label: Text(_isEditing ? 'Save Change' : 'Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
