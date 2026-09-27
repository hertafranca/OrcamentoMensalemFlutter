class DateFormatter {
  static const List<String> _monthNames = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // Remove horas, minutos e segundos. Fica só o dia.
  static DateTime onlyDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }

  // Exemplo: 27 de setembro de 2026
  static String fullDate(DateTime date) {
    final monthName = _monthNames[date.month - 1];

    return '${date.day} de $monthName de ${date.year}';
  }

  // Exemplo: Setembro de 2026
  static String monthAndYear(DateTime date) {
    final monthName = _monthNames[date.month - 1];

    final capitalizedMonth =
        monthName[0].toUpperCase() + monthName.substring(1);

    return '$capitalizedMonth de ${date.year}';
  }

  // Exemplos: Hoje, Ontem, 25 de setembro, 25 de setembro de 2025
  static String dayTitle(DateTime date) {
    final now = DateTime.now();
    final today = onlyDate(now);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (isSameDay(date, today)) {
      return 'TODAY';
    }

    if (isSameDay(date, yesterday)) {
      return 'YESTERDAY';
    }

    final monthName = _monthNames[date.month - 1];
    final dayAndMonth = '${date.day} de $monthName';

    if (date.year == now.year) {
      return dayAndMonth;
    }

    return '$dayAndMonth de ${date.year}';
  }
}
