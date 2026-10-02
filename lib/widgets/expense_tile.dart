import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
// Construtor do widget ExpenseTile, que recebe uma despesa,
// uma função de edição e uma função de exclusão como parâmetros.
  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });
// Função privada para formatar o valor monetário da despesa.
  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }
// Constrói o widget que exibe as informações da despesa,
// incluindo título, categoria, valor e opções de edição/exclusão.
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(expense.title),
        subtitle: Text(
          expense.category.label,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatMoney(expense.amount),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  onEdit();
                }
// Chama a função de exclusão quando a opção "delete" é selecionada
                else  
                if (value == 'delete') {
                  onDelete();
                }
              },
              itemBuilder: (context) {
                return const [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                    // Chama a função de edição quando a 
                    //opção "edit" é selecionada
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                    // Chama a função de exclusão quando 
                    //a opção "delete" é selecionada
                  ),
                ];
              },
            ),
          ],
        ),
      ),
    );
  }
}
