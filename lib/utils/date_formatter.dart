class DateFormatter {
  // Lista de nomes dos meses em inglês.
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
// Verifica se duas datas são do mesmo dia.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
// Verifica se duas datas são do mesmo mês.
  static bool isSameMonth(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month;
  }
// Exemplo: 27/09/2026
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
// Verifica se a data é hoje, ontem ou outro dia e retorna o
// título correspondente.
    if (isSameDay(date, today)) {
      return 'TODAY';
    }
// Verifica se a data é ontem e retorna o título correspondente.
    if (isSameDay(date, yesterday)) {
      return 'YESTERDAY';
    }
// Formata a data como "dia de mês" ou "dia de mês de ano" dependendo do ano.
    final monthName = _monthNames[date.month - 1];
    final dayAndMonth = '${date.day} de $monthName';

    if (date.year == now.year) {
      return dayAndMonth;
    }
// Retorna a data completa com o ano se não for o mesmo ano.S
    return '$dayAndMonth de ${date.year}';
  }
}
