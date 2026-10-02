import 'package:flutter/material.dart';

import '../utils/date_formatter.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
// Widget que permite selecionar o mês atual, com botões para
// navegar para o mês anterior e próximo
  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
  });
// Constrói o widget que exibe o mês selecionado e os botões
// para navegar entre os meses, chamando as funções onPrevious
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Before the Monthly',
            ),
            // Exibe o mês e ano selecionados, formatados usando a função
            // DateFormatter.monthAndYear, centralizados no widget
            Expanded(
              child: Text(
                DateFormatter.monthAndYear(selectedMonth),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                // Exibe o mês e ano selecionados, formatados usando a função
                // DateFormatter.monthAndYear, centralizados no widget
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'After the Monthly',
            ),
            // Botão para navegar para o próximo mês, chamando a função onNext
          ],
        ),
      ),
    );
  }
}
