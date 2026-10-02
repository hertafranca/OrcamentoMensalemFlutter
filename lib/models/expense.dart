import 'expense_category.dart';
//para importar as necessárias bibliotecas e
// arquivos para a execução do código.
class Expense {
  final String id;
  final String title;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;
//define a classe Expense com suas propriedades 
//e um construtor que exige todos os campos obrigatórios.
  const Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });
// O método copyWith permite criar uma cópia de um objeto Expense existente,
// modificando apenas os campos desejados. Ele retorna um novo
// objeto Expense com os valores atualizados.
  Expense copyWith({
    String? id,
    String? title,
    ExpenseCategory? category,
    double? amount,
    DateTime? date,
  }) {
    // Cria uma cópia do objeto Expense atual,
    // permitindo a substituição de campos específicos.
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }
// O método toJson converte um objeto Expense em um mapa JSON,
// facilitando a serialização para armazenamento ou transmissão de dados.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }
// O método fromJson cria um objeto Expense a partir de um mapa JSON,
// permitindo a desserialização de dados recebidos ou armazenados.
  factory Expense.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final dateText = json['date'] as String?;

    // Gastos da Fase 2 não têm data salva.
    // Nesse caso, usamos o momento em que o gasto foi criado (guardado no id).
    final date = dateText == null
        ? _dateFromId(id)
        : DateTime.tryParse(dateText) ?? _dateFromId(id);
// Cria um objeto Expense a partir de um mapa JSON,
// convertendo os campos necessários e lidando com casos em que a data não
// está presente.
    return Expense(
      id: id,
      title: json['title'] as String,
      category: ExpenseCategory.fromName(json['category'] as String),
      amount: (json['amount'] as num).toDouble(),
      date: DateTime(date.year, date.month, date.day),
    );
  }
// O método _dateFromId converte um ID de gasto em uma data,
// permitindo a recuperação da data de criação do gasto a partir do ID.
  static DateTime _dateFromId(String id) {
    final microseconds = int.tryParse(id);

    if (microseconds == null) {
      return DateTime.now();
    }
// Converte o ID do gasto em microsegundos desde a época Unix
// e retorna a data correspondente. Se o ID não for válido, retorna a data atual.
    return DateTime.fromMicrosecondsSinceEpoch(microseconds);
  }
}
