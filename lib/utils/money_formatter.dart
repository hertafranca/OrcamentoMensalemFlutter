class MoneyFormatter {
  // Exemplos:
  // 5      → € 5,00
  // 1300.5 → € 1.300,50
  // -20    → -€ 20,00
  static String format(double value) {
    final isNegative = value < 0;

    // Trabalhamos com centavos para evitar erros de arredondamento.
    final cents = (value.abs() * 100).round();
    final integerPart = cents ~/ 100;
    final decimalPart = (cents % 100).toString().padLeft(2, '0');

    final digits = integerPart.toString();
    final buffer = StringBuffer();

    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);

      final digitsRemaining = digits.length - i - 1;

      if (digitsRemaining > 0 && digitsRemaining % 3 == 0) {
        buffer.write('.');
      }
    }

    final sign = isNegative ? '-' : '';

    return '$sign€ $buffer,$decimalPart';
  }
}
