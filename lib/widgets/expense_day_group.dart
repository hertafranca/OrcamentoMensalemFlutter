import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/date_formatter.dart';
import 'expense_tile.dart';
// Agrupa e exibe despesas por dia, mostrando o total gasto no dia
class ExpenseDayGroup extends StatelessWidget {
  final DateTime day;
  final List<Expense> expenses;
  final void Function(Expense expense) onEdit;
  final void Function(Expense expense) onDelete;
//chamadas de função para editar e excluir despesas.
  const ExpenseDayGroup({
    super.key,
    required this.day,
    required this.expenses,
    required this.onEdit,
    required this.onDelete,
  });
// Formata o valor monetário para o formato europeu
// (com vírgula como separador decimal)
  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
// Constrói o widget que agrupa e exibe as despesas de um dia específico,
// mostrando o total gasto no dia e permitindo a edição ou
// exclusão de cada despesa.
  @override
  Widget build(BuildContext context) {
    final dayTotal = expenses.fold(
      0.0,
      (total, expense) => total + expense.amount,
    );
// Retorna um Column contendo o título do dia, o total gasto e
// uma lista de ExpenseTile para cada despesa do dia
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormatter.dayTitle(day),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  // Espaçamento entre o título do dia e o total gasto
                ),
              ),
              Text(
                _formatMoney(dayTotal),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                // Espaçamento entre o total gasto e a borda direita
              ),
            ],
          ),
        ),
        ...expenses.map(
          (expense) => ExpenseTile(
            expense: expense,
            onEdit: () {
              onEdit(expense);
            },
            onDelete: () {
              onDelete(expense);
            },
          ),
          // Mapeia cada despesa para um ExpenseTile, permitindo a
          // edição e exclusão
        ),
      ],
    );
  }
}
