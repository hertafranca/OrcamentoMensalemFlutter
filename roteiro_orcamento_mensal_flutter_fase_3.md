# Projeto: Orçamento Mensal em Flutter — Fase 3

## Datas, novas categorias e orçamento por mês

Esta fase começa **depois que a Fase 2 estiver completamente funcionando**.

As funcionalidades que vamos adicionar são:

1. Seleção de data no cadastro de um gasto;
2. Novas categorias: Alimentação, Transporte, Lazer, Compras, Casa, Educação e Outros;
3. Tela de metas atualizada para as novas categorias;
4. Histórico agrupado por dia, do mais recente para o mais antigo (`Hoje`, `Ontem`, `25 de setembro`...);
5. Seletor de mês, com resumo e metas calculados apenas com os gastos do mês escolhido.

---
# Como usar este roteiro

Este guia segue a mesma regra das fases anteriores:

> Sempre que um arquivo precisar ser criado ou alterado, o roteiro mostrará o **arquivo completo**.

Não será necessário descobrir onde colocar métodos, imports ou widgets.

A ideia continua sendo montar o projeto como um LEGO:

```text
uma peça
   ↓
testar
   ↓
outra peça
   ↓
testar
```

Não avance se o checkpoint atual não estiver funcionando.

Em algumas etapas o roteiro vai avisar que **o projeto ficará com erro de propósito** até a etapa seguinte. Quando isso acontecer, apenas siga para a próxima etapa sem executar o aplicativo.

---

# O que muda nesta fase

## 1. Todo gasto passa a ter uma data

Antes um gasto tinha:

```text
id
título
categoria
valor
```

Agora terá também:

```text
data
```

No formulário aparecerá um campo `Data`. Ao tocar nele, abre um calendário.

## 2. Novas categorias

| Antes | Depois |
|---|---|
| Restauração | Alimentação |
| Transporte | Transporte |
| Roupas | Compras |
| Educação | Educação |
| Lazer | Lazer |
| — | Casa (nova) |
| — | Outros (nova) |

## 3. Metas continuam valendo para todos os meses

As metas **não** serão diferentes para cada mês.

Se Alimentação tiver meta de `€ 300,00`, isso vale para setembro, outubro, novembro...

O que muda é o cálculo do gasto:

```text
Setembro
  Meta de Alimentação: € 300,00
  Gasto em setembro:   € 120,00

Agosto
  Meta de Alimentação: € 300,00
  Gasto em agosto:     € 280,00
```

## 4. Histórico agrupado por dia

Antes:

```text
Pizza
Uber
Cinema
```

Depois:

```text
Hoje                         € 43,00
  Mercado
  Café

Ontem                        € 12,00
  Uber

25 de setembro               € 20,00
  Cinema
```

## 5. Seletor de mês

No topo da Home aparecerá:

```text
  <     Setembro de 2026     >
```

As setas trocam o mês. O resumo, as metas por categoria e o histórico passam a mostrar **apenas os gastos do mês selecionado**.

A seta `>` fica desativada no mês atual, porque não faz sentido navegar para meses que ainda não aconteceram.

---

# E os dados que já estão salvos?

Se o aplicativo já tem gastos e metas salvos da Fase 2, **eles não serão perdidos**. O código desta fase converte os dados antigos automaticamente:

| Dado antigo | O que acontece |
|---|---|
| Gasto em Restauração | Passa para Alimentação |
| Gasto em Roupas | Passa para Compras |
| Meta de Restauração | Passa para Alimentação |
| Meta de Roupas | Passa para Compras |
| Gasto sem data | Recebe a data do dia em que foi cadastrado |

Como isso é possível para a data?

Na Fase 2, o `id` de cada gasto foi criado assim:

```dart
DateTime.now().microsecondsSinceEpoch.toString()
```

Ou seja, o `id` já guarda o momento exato em que o gasto foi cadastrado. Vamos usar esse número para descobrir a data dos gastos antigos.

---

# Estrutura final da Fase 3

Ao terminar, a pasta `lib` ficará assim:

```text
lib/
├── main.dart
├── models/
│   ├── expense.dart
│   └── expense_category.dart
├── screens/
│   ├── home_page.dart
│   ├── add_expense_page.dart
│   └── budget_goals_page.dart
├── services/
│   └── local_storage_service.dart
├── utils/
│   └── date_formatter.dart
└── widgets/
    ├── expense_tile.dart
    ├── expense_day_group.dart
    ├── month_selector.dart
    ├── budget_summary_card.dart
    └── category_budget_card.dart
```

Novidades:

```text
utils/date_formatter.dart          (novo)
widgets/expense_day_group.dart     (novo)
widgets/month_selector.dart        (novo)
```

---

# Etapa 1 — Colocar o aplicativo em português

O calendário do Flutter vem em inglês por padrão (`January`, `Cancel`...).

Para ele aparecer em português, precisamos de um pacote que já vem com o Flutter.

Pare o aplicativo, se estiver rodando.

No terminal, na pasta do projeto, execute:

```bash
flutter pub add flutter_localizations --sdk=flutter
```

Depois:

```bash
flutter pub get
```

Agora abra:

```text
lib/main.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_page.dart';

void main() {
  runApp(const BudgetApp());
}

class BudgetApp extends StatelessWidget {
  const BudgetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Orçamento Mensal',
      locale: const Locale('pt', 'PT'),
      supportedLocales: const [
        Locale('pt', 'PT'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
```

## O que mudou

Adicionamos três coisas ao `MaterialApp`:

```dart
locale:
```

diz qual idioma o aplicativo usa.

```dart
supportedLocales:
```

lista os idiomas suportados.

```dart
localizationsDelegates:
```

carrega as traduções dos componentes do Flutter (calendário, botões `OK` e `Cancelar`, etc.).

## Checkpoint

Como o `pubspec.yaml` mudou, **não use Hot Reload**. Execute novamente:

```bash
flutter run
```

- [ ] `flutter pub add flutter_localizations --sdk=flutter` terminou sem erro.
- [ ] O aplicativo abre normalmente.
- [ ] Os gastos e metas da Fase 2 continuam aparecendo.
- [ ] Não existem erros vermelhos.

Visualmente nada muda ainda. Isso é normal.

---

# Etapa 2 — Criar o formatador de datas

Vamos precisar mostrar datas de várias formas:

```text
27 de setembro de 2026     → no formulário
Setembro de 2026           → no seletor de mês
Hoje / Ontem / 25 de setembro → no histórico
```

Para não repetir esse código em vários arquivos, vamos criar uma classe só para isso.

Crie a pasta:

```text
lib/utils
```

Crie o arquivo:

```text
lib/utils/date_formatter.dart
```

Copie o arquivo completo:

```dart
class DateFormatter {
  static const List<String> _monthNames = [
    'janeiro',
    'fevereiro',
    'março',
    'abril',
    'maio',
    'junho',
    'julho',
    'agosto',
    'setembro',
    'outubro',
    'novembro',
    'dezembro',
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
      return 'Hoje';
    }

    if (isSameDay(date, yesterday)) {
      return 'Ontem';
    }

    final monthName = _monthNames[date.month - 1];
    final dayAndMonth = '${date.day} de $monthName';

    if (date.year == now.year) {
      return dayAndMonth;
    }

    return '$dayAndMonth de ${date.year}';
  }
}
```

## O que esta classe faz

Todos os métodos são `static`. Isso significa que podemos usá-los sem criar um objeto:

```dart
DateFormatter.fullDate(DateTime.now());
```

Um detalhe importante:

```dart
DateTime(now.year, now.month, now.day - 1)
```

Se hoje for dia `1`, isso vira dia `0`. O Dart entende automaticamente que dia `0` é o último dia do mês anterior. Então `Ontem` funciona também na virada do mês.

## Checkpoint

- [ ] A pasta `utils` existe.
- [ ] `date_formatter.dart` existe.
- [ ] Não existem erros vermelhos.
- [ ] O aplicativo continua compilando.

Ainda não estamos usando esta classe.

---

# Etapa 3 — Atualizar as categorias

Abra:

```text
lib/models/expense_category.dart
```

Apague tudo e copie o arquivo completo:

```dart
enum ExpenseCategory {
  food('Alimentação'),
  transport('Transporte'),
  leisure('Lazer'),
  shopping('Compras'),
  home('Casa'),
  education('Educação'),
  other('Outros');

  final String label;

  const ExpenseCategory(this.label);

  // Converte o nome salvo no celular de volta para uma categoria.
  // Também converte as categorias antigas da Fase 2.
  static ExpenseCategory fromName(String name) {
    if (name == 'restaurant') {
      return ExpenseCategory.food;
    }

    if (name == 'clothes') {
      return ExpenseCategory.shopping;
    }

    return ExpenseCategory.values.firstWhere(
      (category) => category.name == name,
      orElse: () => ExpenseCategory.other,
    );
  }
}
```

## O que mudou

As categorias agora são sete, na ordem pedida.

Também criamos:

```dart
ExpenseCategory.fromName()
```

Quando o aplicativo salva um gasto, ele salva o **nome interno** da categoria (`food`, `transport`...).

Na Fase 2 existiam os nomes `restaurant` e `clothes`, que não existem mais. O método `fromName` faz a tradução:

```text
restaurant  →  food      (Alimentação)
clothes     →  shopping  (Compras)
```

Se aparecer um nome desconhecido, o gasto vai para `Outros`.

## Importante

Depois desta alteração, o projeto mostrará erro em:

```text
lib/models/expense.dart
```

Isso é esperado. O arquivo ainda usa `ExpenseCategory.restaurant`, que não existe mais.

Vamos corrigir na próxima etapa.

Não execute o aplicativo ainda.

---

# Etapa 4 — Adicionar a data ao gasto

Abra:

```text
lib/models/expense.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'expense_category.dart';

class Expense {
  final String id;
  final String title;
  final ExpenseCategory category;
  final double amount;
  final DateTime date;

  const Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.date,
  });

  Expense copyWith({
    String? id,
    String? title,
    ExpenseCategory? category,
    double? amount,
    DateTime? date,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'amount': amount,
      'date': date.toIso8601String(),
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as String;
    final dateText = json['date'] as String?;

    // Gastos da Fase 2 não têm data salva.
    // Nesse caso, usamos o momento em que o gasto foi criado (guardado no id).
    final date = dateText == null
        ? _dateFromId(id)
        : DateTime.tryParse(dateText) ?? _dateFromId(id);

    return Expense(
      id: id,
      title: json['title'] as String,
      category: ExpenseCategory.fromName(
        json['category'] as String,
      ),
      amount: (json['amount'] as num).toDouble(),
      date: DateTime(date.year, date.month, date.day),
    );
  }

  static DateTime _dateFromId(String id) {
    final microseconds = int.tryParse(id);

    if (microseconds == null) {
      return DateTime.now();
    }

    return DateTime.fromMicrosecondsSinceEpoch(microseconds);
  }
}
```

## O que mudou

Novo campo:

```dart
final DateTime date;
```

No `toJson()`, a data é transformada em texto:

```dart
'date': date.toIso8601String(),
```

Exemplo do texto salvo:

```text
2026-09-27T00:00:00.000
```

No `fromJson()`:

- a categoria agora usa `ExpenseCategory.fromName`;
- se o gasto não tiver data (dados da Fase 2), a data é descoberta pelo `id`.

## Importante

Depois desta alteração, o projeto mostrará erro em:

```text
lib/screens/add_expense_page.dart
```

Isso é esperado. O construtor de `Expense` agora exige:

```dart
date:
```

Não execute o aplicativo ainda. Primeiro vamos atualizar o serviço de armazenamento (Etapa 5) e depois o formulário (Etapa 6).

---

# Etapa 5 — Converter as metas antigas

As metas são salvas assim no celular:

```text
{"restaurant": 300, "transport": 150, "clothes": 100, ...}
```

Precisamos que `restaurant` vire Alimentação e `clothes` vire Compras também nas metas.

> **Por que fazer isso antes de rodar o app?**
> Se o aplicativo abrir sem essa conversão e alguém salvar as metas, as metas antigas de Restauração e Roupas seriam apagadas.

Abra:

```text
lib/services/local_storage_service.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';

class LocalStorageService {
  static const String _expensesKey = 'expenses';
  static const String _goalsKey = 'goals';

  final SharedPreferencesAsync _preferences = SharedPreferencesAsync();

  Map<ExpenseCategory, double> _emptyGoals() {
    return {
      for (final category in ExpenseCategory.values) category: 0.0,
    };
  }

  Future<void> saveExpenses(List<Expense> expenses) async {
    final expensesAsJson = expenses
        .map(
          (expense) => expense.toJson(),
        )
        .toList();

    final encodedExpenses = jsonEncode(expensesAsJson);

    await _preferences.setString(
      _expensesKey,
      encodedExpenses,
    );
  }

  Future<List<Expense>> loadExpenses() async {
    final encodedExpenses = await _preferences.getString(
      _expensesKey,
    );

    if (encodedExpenses == null || encodedExpenses.isEmpty) {
      return [];
    }

    try {
      final decodedExpenses = jsonDecode(encodedExpenses) as List<dynamic>;

      return decodedExpenses.map((item) {
        final map = Map<String, dynamic>.from(item as Map);

        return Expense.fromJson(map);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveGoals(Map<ExpenseCategory, double> goals) async {
    final goalsAsJson = {
      for (final category in ExpenseCategory.values)
        category.name: goals[category] ?? 0.0,
    };

    final encodedGoals = jsonEncode(goalsAsJson);

    await _preferences.setString(
      _goalsKey,
      encodedGoals,
    );
  }

  Future<Map<ExpenseCategory, double>> loadGoals() async {
    final encodedGoals = await _preferences.getString(
      _goalsKey,
    );

    if (encodedGoals == null || encodedGoals.isEmpty) {
      return _emptyGoals();
    }

    try {
      final decodedGoals = Map<String, dynamic>.from(
        jsonDecode(encodedGoals) as Map,
      );

      final goals = _emptyGoals();

      for (final entry in decodedGoals.entries) {
        final category = ExpenseCategory.fromName(entry.key);
        final value = (entry.value as num?)?.toDouble() ?? 0.0;

        goals[category] = value;
      }

      return goals;
    } catch (_) {
      return _emptyGoals();
    }
  }
}
```

## O que mudou

Só o `loadGoals()` mudou de verdade.

Antes ele procurava cada categoria pelo nome novo. Agora ele lê **tudo o que está salvo** e passa cada nome por `ExpenseCategory.fromName`:

```text
restaurant: 300   →   Alimentação: 300
clothes: 100      →   Compras: 100
transport: 150    →   Transporte: 150
```

Categorias novas (Casa e Outros) começam com `0`.

Também criamos `_emptyGoals()` para não repetir o mapa de metas zeradas.

Ainda existe erro em `add_expense_page.dart`. Não execute o aplicativo ainda.

---

# Etapa 6 — Adicionar a data no formulário de gasto

Abra:

```text
lib/screens/add_expense_page.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../utils/date_formatter.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? expenseToEdit;

  const AddExpensePage({
    super.key,
    this.expenseToEdit,
  });

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _amountController;

  ExpenseCategory? _selectedCategory;
  late DateTime _selectedDate;

  bool get _isEditing {
    return widget.expenseToEdit != null;
  }

  @override
  void initState() {
    super.initState();

    final expense = widget.expenseToEdit;

    _titleController = TextEditingController(
      text: expense?.title ?? '',
    );

    _amountController = TextEditingController(
      text: expense == null ? '' : expense.amount.toStringAsFixed(2),
    );

    _selectedCategory = expense?.category;

    // Novo gasto: começa com a data de hoje.
    // Edição: começa com a data do gasto.
    _selectedDate = expense?.date ?? DateFormatter.onlyDate(DateTime.now());
  }

  Future<void> _pickDate() async {
    final today = DateFormatter.onlyDate(DateTime.now());

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today) ? today : _selectedDate,
      firstDate: DateTime(2000),
      lastDate: today,
      helpText: 'Data do gasto',
    );

    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = DateFormatter.onlyDate(pickedDate);
    });
  }

  void _saveExpense() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final amount = double.parse(
      _amountController.text.replaceAll(',', '.'),
    );

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar gasto' : 'Novo gasto',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Título',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe um título';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<ExpenseCategory>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    border: OutlineInputBorder(),
                  ),
                  items: ExpenseCategory.values.map((category) {
                    return DropdownMenuItem<ExpenseCategory>(
                      value: category,
                      child: Text(category.label),
                    );
                  }).toList(),
                  onChanged: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Selecione uma categoria';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    prefixText: '€ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe o valor';
                    }

                    final amount = double.tryParse(
                      value.replaceAll(',', '.'),
                    );

                    if (amount == null) {
                      return 'Informe um valor válido';
                    }

                    if (amount <= 0) {
                      return 'O valor deve ser maior que zero';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Data',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      DateFormatter.fullDate(_selectedDate),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveExpense,
                  child: Text(
                    _isEditing ? 'Salvar alterações' : 'Adicionar gasto',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## O que mudou

Nova variável:

```dart
late DateTime _selectedDate;
```

Novo método que abre o calendário:

```dart
_pickDate()
```

Ele usa `showDatePicker`, que é o calendário pronto do Flutter:

```dart
firstDate: DateTime(2000),   // data mais antiga permitida
lastDate: today,             // não permite datas no futuro
```

Novo campo na tela:

```dart
InkWell(
  onTap: _pickDate,
  child: InputDecorator(...),
)
```

`InputDecorator` desenha a caixa com borda igual aos outros campos. `InkWell` faz a caixa reagir ao toque.

Como sempre existe uma data selecionada (hoje, por padrão), esse campo não precisa de validação.

## Checkpoint

Agora o projeto deve compilar novamente.

Pare o aplicativo e execute:

```bash
flutter run
```

### Teste 1 — Dados antigos (pule se não houver dados da Fase 2)

- [ ] Os gastos antigos continuam aparecendo.
- [ ] Gastos que eram `Restauração` agora aparecem como `Alimentação`.
- [ ] Gastos que eram `Roupas` agora aparecem como `Compras`.
- [ ] Na lista de metas por categoria aparecem as **sete** categorias.
- [ ] A meta que era de Restauração agora está em Alimentação.
- [ ] A meta que era de Roupas agora está em Compras.
- [ ] Casa e Outros aparecem com meta `€ 0,00`.

### Teste 2 — Formulário

Toque em `+`.

- [ ] Aparece o campo `Data` com a data de hoje (exemplo: `27 de setembro de 2026`).
- [ ] Ao tocar em `Data`, o calendário abre.
- [ ] O calendário está em português.
- [ ] Não é possível escolher um dia no futuro.
- [ ] Ao escolher um dia e tocar em `OK`, o campo mostra a nova data.
- [ ] Ao tocar em `Cancelar`, a data não muda.
- [ ] A lista de categorias mostra: Alimentação, Transporte, Lazer, Compras, Casa, Educação, Outros.

Cadastre um gasto qualquer com a data de ontem.

- [ ] O gasto é salvo e aparece no histórico.

### Teste 3 — Edição

Abra o menu desse gasto e escolha `Editar`.

- [ ] O formulário abre com a data que foi escolhida (ontem), e não com a data de hoje.

Nesta etapa o histórico **ainda não** está agrupado por dia, e o resumo ainda soma todos os meses. Isso será feito nas próximas etapas.

---

# Etapa 7 — Atualizar a tela de metas

A tela de metas já monta um campo para cada categoria automaticamente, por causa deste trecho:

```dart
...ExpenseCategory.values.map(...)
```

Então os sete campos já aparecem. Vamos apenas melhorar a tela para o novo modelo:

- deixar claro que as metas valem para todos os meses;
- mostrar o total mensal enquanto os valores são digitados.

Abra:

```text
lib/screens/budget_goals_page.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense_category.dart';

class BudgetGoalsPage extends StatefulWidget {
  final Map<ExpenseCategory, double> currentGoals;

  const BudgetGoalsPage({
    super.key,
    required this.currentGoals,
  });

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

  // Soma o que está digitado nos campos neste momento.
  double get _totalGoals {
    double total = 0;

    for (final controller in _controllers.values) {
      final value = double.tryParse(
        controller.text.replaceAll(',', '.'),
      );

      if (value != null && value > 0) {
        total += value;
      }
    }

    return total;
  }

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
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
      appBar: AppBar(
        title: const Text('Metas mensais'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Defina quanto pretende gastar por mês em cada categoria.',
                ),
                const SizedBox(height: 8),
                const Text(
                  'Estas metas valem para todos os meses. '
                  'O consumo é calculado separadamente em cada mês.',
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
                      onChanged: (_) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe uma meta';
                        }

                        final goal = double.tryParse(
                          value.replaceAll(',', '.'),
                        );

                        if (goal == null) {
                          return 'Informe um valor válido';
                        }

                        if (goal < 0) {
                          return 'A meta não pode ser negativa';
                        }

                        return null;
                      },
                    ),
                  );
                }),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Total mensal',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(
                          _formatMoney(_totalGoals),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveGoals,
                  child: const Text('Salvar metas'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

## O que mudou

O título virou `Metas mensais`.

Cada campo agora tem:

```dart
onChanged: (_) {
  setState(() {});
},
```

Isso pede para a tela ser redesenhada a cada tecla digitada. Assim o `Total mensal` é recalculado na hora.

## Checkpoint

Toque no botão de metas (canto superior direito).

- [ ] O título da tela é `Metas mensais`.
- [ ] Existem sete campos, na ordem: Alimentação, Transporte, Lazer, Compras, Casa, Educação, Outros.
- [ ] O `Total mensal` aparece no fim da tela.
- [ ] Ao alterar um valor, o total muda imediatamente.
- [ ] As validações continuam funcionando (vazio, `abc`, negativo).
- [ ] Ao salvar, o resumo da Home é atualizado.
- [ ] Ao fechar e abrir o app, as metas continuam salvas.

---

# Etapa 8 — Criar o seletor de mês

Crie o arquivo:

```text
lib/widgets/month_selector.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../utils/date_formatter.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;

  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Mês anterior',
            ),
            Expanded(
              child: Text(
                DateFormatter.monthAndYear(selectedMonth),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Próximo mês',
            ),
          ],
        ),
      ),
    );
  }
}
```

## Detalhe importante

Repare no ponto de interrogação:

```dart
final VoidCallback? onNext;
```

Isso permite passar `null`. Quando um `IconButton` recebe `onPressed: null`, o Flutter mostra o botão **desativado** (cinza). Vamos usar isso para desativar a seta `>` no mês atual.

## Checkpoint

- [ ] `month_selector.dart` existe.
- [ ] Não existem erros vermelhos.
- [ ] O aplicativo continua compilando.

Ainda não estamos usando este widget.

---

# Etapa 9 — Criar o grupo de gastos de um dia

Este widget mostra o título do dia, o total gasto naquele dia e os gastos logo abaixo:

```text
Hoje                         € 53,00
┌────────────────────────────────────┐
│ Café                   € 3,00   ⋮  │
│ Alimentação                        │
└────────────────────────────────────┘
┌────────────────────────────────────┐
│ Mercado               € 50,00   ⋮  │
│ Alimentação                        │
└────────────────────────────────────┘
```

Crie o arquivo:

```text
lib/widgets/expense_day_group.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../utils/date_formatter.dart';
import 'expense_tile.dart';

class ExpenseDayGroup extends StatelessWidget {
  final DateTime day;
  final List<Expense> expenses;
  final void Function(Expense expense) onEdit;
  final void Function(Expense expense) onDelete;

  const ExpenseDayGroup({
    super.key,
    required this.day,
    required this.expenses,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final dayTotal = expenses.fold(
      0.0,
      (total, expense) => total + expense.amount,
    );

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
                ),
              ),
              Text(
                _formatMoney(dayTotal),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
        ),
      ],
    );
  }
}
```

## O que tem de diferente aqui

No `ExpenseTile` (Fase 2) usamos:

```dart
final VoidCallback onEdit;
```

`VoidCallback` é uma função **sem parâmetros**.

Aqui usamos:

```dart
final void Function(Expense expense) onEdit;
```

É uma função que **recebe um gasto**. Assim o grupo avisa para a Home qual gasto foi tocado.

O arquivo `expense_tile.dart` **não precisa ser alterado** nesta fase.

## Checkpoint

- [ ] `expense_day_group.dart` existe.
- [ ] Não existem erros vermelhos.
- [ ] O aplicativo continua compilando.

Ainda não estamos usando este widget.

---

# Etapa 10 — Montar a Home com seletor de mês e histórico por dia

Agora vamos ligar todas as peças.

Abra:

```text
lib/screens/home_page.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../services/local_storage_service.dart';
import '../utils/date_formatter.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_budget_card.dart';
import '../widgets/expense_day_group.dart';
import '../widgets/month_selector.dart';
import 'add_expense_page.dart';
import 'budget_goals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorageService _storage = LocalStorageService();

  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category in ExpenseCategory.values) category: 0.0,
  };

  bool _isLoading = true;

  // O mês selecionado é guardado como o dia 1 daquele mês.
  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  bool get _isCurrentMonth {
    return DateFormatter.isSameMonth(_selectedMonth, DateTime.now());
  }

  // Apenas os gastos do mês selecionado, do mais recente para o mais antigo.
  List<Expense> get _monthExpenses {
    final expenses = _expenses
        .where(
          (expense) => DateFormatter.isSameMonth(
            expense.date,
            _selectedMonth,
          ),
        )
        .toList();

    expenses.sort((a, b) {
      final byDate = b.date.compareTo(a.date);

      if (byDate != 0) {
        return byDate;
      }

      // Mesmo dia: o cadastrado por último aparece primeiro.
      return b.id.compareTo(a.id);
    });

    return expenses;
  }

  // Agrupa os gastos do mês por dia.
  Map<DateTime, List<Expense>> get _expensesByDay {
    final groups = <DateTime, List<Expense>>{};

    for (final expense in _monthExpenses) {
      final day = DateFormatter.onlyDate(expense.date);

      groups.putIfAbsent(day, () => []).add(expense);
    }

    return groups;
  }

  double get _totalSpent {
    return _monthExpenses.fold(
      0.0,
      (total, expense) => total + expense.amount,
    );
  }

  double get _totalBudget {
    return _goals.values.fold(
      0.0,
      (total, goal) => total + goal,
    );
  }

  double spentByCategory(ExpenseCategory category) {
    return _monthExpenses
        .where(
          (expense) => expense.category == category,
        )
        .fold(
          0.0,
          (total, expense) => total + expense.amount,
        );
  }

  void _goToPreviousMonth() {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month - 1,
      );
    });
  }

  void _goToNextMonth() {
    if (_isCurrentMonth) {
      return;
    }

    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + 1,
      );
    });
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    final expenses = await _storage.loadExpenses();
    final goals = await _storage.loadGoals();

    if (!mounted) {
      return;
    }

    setState(() {
      _expenses
        ..clear()
        ..addAll(expenses);

      _goals
        ..clear()
        ..addAll(goals);

      _isLoading = false;
    });
  }

  Future<void> _openAddExpense() async {
    final expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpensePage(),
      ),
    );

    if (expense == null || !mounted) {
      return;
    }

    setState(() {
      _expenses.add(expense);

      // Mostra o mês do gasto que acabou de ser cadastrado.
      _selectedMonth = DateTime(
        expense.date.year,
        expense.date.month,
      );
    });

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _editExpense(Expense expense) async {
    final updatedExpense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpensePage(
          expenseToEdit: expense,
        ),
      ),
    );

    if (updatedExpense == null || !mounted) {
      return;
    }

    final index = _expenses.indexWhere(
      (item) => item.id == updatedExpense.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _expenses[index] = updatedExpense;

      // Se a data mudou de mês, acompanha o gasto.
      _selectedMonth = DateTime(
        updatedExpense.date.year,
        updatedExpense.date.month,
      );
    });

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _deleteExpense(Expense expense) async {
    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Excluir gasto'),
              content: Text(
                'Deseja realmente excluir "${expense.title}"?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancelar'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Excluir'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!shouldDelete || !mounted) {
      return;
    }

    setState(() {
      _expenses.removeWhere(
        (item) => item.id == expense.id,
      );
    });

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _openBudgetGoals() async {
    final goals = await Navigator.push<Map<ExpenseCategory, double>>(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetGoalsPage(
          currentGoals: Map.of(_goals),
        ),
      ),
    );

    if (goals == null || !mounted) {
      return;
    }

    setState(() {
      _goals
        ..clear()
        ..addAll(goals);
    });

    await _storage.saveGoals(_goals);
  }

  @override
  Widget build(BuildContext context) {
    final expensesByDay = _expensesByDay;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento Mensal'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: 'Editar metas',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MonthSelector(
                      selectedMonth: _selectedMonth,
                      onPrevious: _goToPreviousMonth,
                      onNext: _isCurrentMonth ? null : _goToNextMonth,
                    ),
                    const SizedBox(height: 16),
                    BudgetSummaryCard(
                      budget: _totalBudget,
                      spent: _totalSpent,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Metas por categoria',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...ExpenseCategory.values.map(
                      (category) => CategoryBudgetCard(
                        category: category,
                        goal: _goals[category] ?? 0,
                        spent: spentByCategory(category),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Histórico de transações',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (expensesByDay.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Nenhum gasto neste mês.'),
                        ),
                      )
                    else
                      ...expensesByDay.entries.map(
                        (entry) => ExpenseDayGroup(
                          day: entry.key,
                          expenses: entry.value,
                          onEdit: (expense) {
                            _editExpense(expense);
                          },
                          onDelete: (expense) {
                            _deleteExpense(expense);
                          },
                        ),
                      ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _openAddExpense,
              child: const Icon(Icons.add),
            ),
    );
  }
}
```

## O que mudou

### 1. Mês selecionado

```dart
DateTime _selectedMonth
```

Guarda o mês que está sendo visto. Começa no mês atual.

As setas somam ou subtraem um mês:

```dart
DateTime(_selectedMonth.year, _selectedMonth.month - 1)
```

Assim como no `Ontem`, o Dart resolve a virada de ano sozinho: mês `0` de 2026 vira dezembro de 2025.

### 2. Gastos do mês

```dart
List<Expense> get _monthExpenses
```

Filtra os gastos do mês selecionado e ordena do mais recente para o mais antigo.

**Todos os cálculos agora usam `_monthExpenses`** em vez de `_expenses`:

```text
_totalSpent        → gasto do mês
spentByCategory()  → gasto da categoria no mês
_expensesByDay     → histórico do mês
```

A lista `_expenses` continua guardando **todos** os gastos. É ela que é salva no celular.

### 3. Agrupamento por dia

```dart
groups.putIfAbsent(day, () => []).add(expense);
```

Lê-se assim: "se ainda não existe um grupo para este dia, crie uma lista vazia; depois adicione o gasto nela".

Como os gastos já estavam ordenados, os grupos também ficam em ordem.

### 4. Pular para o mês do gasto

Ao cadastrar ou editar um gasto, a Home muda para o mês desse gasto. Assim o gasto aparece na tela logo depois de salvar, mesmo que seja de um mês anterior.

## Checkpoint

- [ ] A Home abre sem erros.
- [ ] O seletor de mês aparece no topo com o mês atual (exemplo: `Setembro de 2026`).
- [ ] A seta `>` está desativada.
- [ ] O histórico aparece agrupado por dia.
- [ ] O botão `+` continua funcionando.
- [ ] O botão de metas continua funcionando.
- [ ] Editar e excluir continuam funcionando.

---

# Etapa 11 — Testar o histórico por dia

> Os exemplos abaixo supõem que **hoje é 27 de setembro de 2026**. Se estiver fazendo em outro dia, as datas mudam, mas a lógica é a mesma: use hoje, ontem e dias anteriores do mês atual.

> Se já existirem gastos no mês atual (da Fase 2), eles também vão aparecer. Para conferir os totais com facilidade, exclua-os antes ou some-os mentalmente.

Cadastre os gastos **nesta ordem** (a ordem fora de sequência é proposital):

```text
Título: Luz
Categoria: Casa
Valor: 60
Data: 10 de setembro
```

```text
Título: Cinema
Categoria: Lazer
Valor: 20
Data: 25 de setembro
```

```text
Título: Mercado
Categoria: Alimentação
Valor: 50
Data: hoje
```

```text
Título: Uber
Categoria: Transporte
Valor: 12
Data: ontem
```

```text
Título: Café
Categoria: Alimentação
Valor: 3
Data: hoje
```

## Resultado esperado

Mesmo cadastrados fora de ordem, o histórico deve aparecer assim:

```text
Hoje                         € 53,00
  Café            Alimentação   € 3,00
  Mercado         Alimentação  € 50,00

Ontem                        € 12,00
  Uber            Transporte   € 12,00

25 de setembro               € 20,00
  Cinema          Lazer        € 20,00

10 de setembro               € 60,00
  Luz             Casa         € 60,00
```

Dentro de `Hoje`, o Café aparece antes do Mercado porque foi cadastrado depois.

## Checkpoint

- [ ] Os grupos estão do mais recente para o mais antigo.
- [ ] O grupo de hoje se chama `Hoje`.
- [ ] O grupo de ontem se chama `Ontem`.
- [ ] Os outros dias aparecem como `25 de setembro`, `10 de setembro`.
- [ ] Cada grupo mostra o total do dia.
- [ ] Dentro do mesmo dia, o último cadastrado aparece primeiro.

---

# Etapa 12 — Testar o orçamento por mês

## 1. Configure as metas

```text
Alimentação: 300
Transporte:  100
Lazer:       150
Compras:     200
Casa:        400
Educação:    100
Outros:      50
```

Antes de salvar, confira na própria tela:

```text
Total mensal: € 1300,00
```

Salve.

## 2. Confira setembro

```text
Orçamento: € 1300,00
Gasto:     € 145,00
Restante:  € 1155,00
```

Categorias:

```text
Alimentação   € 53,00 de € 300,00
Transporte    € 12,00 de € 100,00
Lazer         € 20,00 de € 150,00
Compras        € 0,00 de € 200,00
Casa          € 60,00 de € 400,00
Educação       € 0,00 de € 100,00
Outros         € 0,00 de € 50,00
```

## 3. Cadastre um gasto do mês passado

```text
Título: Livro
Categoria: Educação
Valor: 25
Data: 20 de agosto
```

Ao salvar, a Home deve mudar sozinha para:

```text
<     Agosto de 2026     >
```

E mostrar:

```text
Orçamento: € 1300,00
Gasto:     € 25,00
Restante:  € 1275,00
```

Educação:

```text
€ 25,00 de € 100,00
Ainda pode gastar € 75,00.
```

Histórico:

```text
20 de agosto                 € 25,00
  Livro           Educação     € 25,00
```

## 4. Navegue entre os meses

Toque em `>`.

- Volta para `Setembro de 2026`.
- O Livro **não** aparece em setembro.
- Educação de setembro continua `€ 0,00 de € 100,00`.
- A seta `>` fica desativada.

Toque em `<` duas vezes.

- Aparece `Julho de 2026`.
- O histórico mostra `Nenhum gasto neste mês.`
- Gasto: `€ 0,00`.
- Restante: `€ 1300,00`.

## Checkpoint

- [ ] O total das metas é `€ 1300,00`.
- [ ] Setembro mostra gasto de `€ 145,00`.
- [ ] Cadastrar um gasto de agosto leva a Home para agosto.
- [ ] Agosto mostra apenas o Livro.
- [ ] Setembro não mostra o Livro.
- [ ] As metas são as mesmas em todos os meses.
- [ ] O consumo de cada categoria muda conforme o mês.
- [ ] A seta `>` fica desativada no mês atual.
- [ ] Um mês sem gastos mostra `Nenhum gasto neste mês.`

---

# Etapa 13 — Testar a mudança de data na edição

Volte para setembro.

Abra o menu do gasto `Cinema` e escolha `Editar`.

Altere apenas a data:

```text
Data: 30 de agosto
```

Toque em `Salvar alterações`.

## Resultado esperado

A Home muda para agosto:

```text
Gasto: € 45,00

30 de agosto                 € 20,00
  Cinema          Lazer        € 20,00

20 de agosto                 € 25,00
  Livro           Educação     € 25,00
```

Toque em `>` para voltar a setembro:

```text
Gasto: € 125,00
```

- O grupo `25 de setembro` desapareceu.
- Lazer de setembro voltou para `€ 0,00 de € 150,00`.

## Checkpoint

- [ ] Editar abre o formulário com a data atual do gasto.
- [ ] Mudar a data leva o gasto para o outro mês.
- [ ] O gasto sai do resumo do mês antigo.
- [ ] O gasto entra no resumo do mês novo.
- [ ] O total geral de todos os gastos não mudou (o valor continua `€ 20`).

---

# Etapa 14 — Testar persistência e exclusão

## 1. Reinicie

Feche o aplicativo completamente (não use Hot Reload) e execute:

```bash
flutter run
```

- [ ] O aplicativo abre no **mês atual**.
- [ ] Os gastos continuam nos dias corretos.
- [ ] As metas continuam iguais.
- [ ] Agosto continua com Cinema e Livro.

## 2. Exclua um gasto

Em setembro, exclua:

```text
Luz
Casa
€ 60
```

Resultado esperado em setembro:

```text
Gasto: € 65,00
```

- [ ] O grupo `10 de setembro` desapareceu.
- [ ] Casa voltou para `€ 0,00 de € 400,00`.

Reinicie o aplicativo novamente.

- [ ] A Luz não voltou.

## Dica

Se abrir o aplicativo amanhã, o grupo que hoje se chama `Hoje` passará a se chamar `Ontem`. Isso é o comportamento esperado.

---

# Resultado visual esperado

```text
ORÇAMENTO MENSAL                         ⚙

┌──────────────────────────────────────┐
│  <       Setembro de 2026        >   │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ Resumo do mês                        │
│ Orçamento: € 1300,00                 │
│ Gasto:     € 65,00                   │
│ Restante:  € 1235,00                 │
│ Você está dentro do orçamento.       │
└──────────────────────────────────────┘

METAS POR CATEGORIA

┌──────────────────────────────────────┐
│ Alimentação                          │
│ € 53,00 de € 300,00                  │
│ ███░░░░░░░░░░░░░░░                  │
│ Ainda pode gastar € 247,00.          │
└──────────────────────────────────────┘

...

HISTÓRICO DE TRANSAÇÕES

Hoje                          € 53,00
┌──────────────────────────────────────┐
│ Café                    € 3,00    ⋮  │
│ Alimentação                          │
└──────────────────────────────────────┘
┌──────────────────────────────────────┐
│ Mercado                € 50,00    ⋮  │
│ Alimentação                          │
└──────────────────────────────────────┘

Ontem                         € 12,00
┌──────────────────────────────────────┐
│ Uber                   € 12,00    ⋮  │
│ Transporte                           │
└──────────────────────────────────────┘

                                   [ + ]
```

---

# Checklist da Fase 3

## Idioma

- [ ] `flutter_localizations` instalado.
- [ ] O calendário aparece em português.

## Data do gasto

- [ ] O formulário tem o campo `Data`.
- [ ] Novo gasto começa com a data de hoje.
- [ ] O calendário não permite datas futuras.
- [ ] A data é salva.
- [ ] A edição abre com a data do gasto.
- [ ] É possível alterar a data na edição.

## Categorias

- [ ] Existem sete categorias: Alimentação, Transporte, Lazer, Compras, Casa, Educação, Outros.
- [ ] Gastos antigos de Restauração viraram Alimentação.
- [ ] Gastos antigos de Roupas viraram Compras.
- [ ] Gastos antigos receberam a data em que foram cadastrados.

## Metas

- [ ] A tela de metas tem sete campos.
- [ ] Metas antigas foram convertidas.
- [ ] O total mensal é atualizado enquanto se digita.
- [ ] As metas valem para todos os meses.

## Histórico

- [ ] Agrupado por dia.
- [ ] Do mais recente para o mais antigo.
- [ ] Mostra `Hoje` e `Ontem`.
- [ ] Mostra `25 de setembro` para os outros dias.
- [ ] Mostra o total de cada dia.

## Orçamento por mês

- [ ] Existe o seletor de mês.
- [ ] O app abre no mês atual.
- [ ] É possível voltar para meses anteriores.
- [ ] Não é possível avançar além do mês atual.
- [ ] O resumo considera apenas o mês selecionado.
- [ ] Cada categoria considera apenas o mês selecionado.
- [ ] Cadastrar ou editar um gasto leva a Home para o mês dele.

---

# Arquivos alterados nesta fase

Modificados:

```text
lib/main.dart
lib/models/expense.dart
lib/models/expense_category.dart
lib/screens/add_expense_page.dart
lib/screens/budget_goals_page.dart
lib/screens/home_page.dart
lib/services/local_storage_service.dart
```

Novos:

```text
lib/utils/date_formatter.dart
lib/widgets/month_selector.dart
lib/widgets/expense_day_group.dart
```

Não foram alterados:

```text
lib/widgets/expense_tile.dart
lib/widgets/budget_summary_card.dart
lib/widgets/category_budget_card.dart
```

Nova dependência:

```text
flutter_localizations
```

---

# O que foi aprendido nesta fase

Além do conteúdo das fases anteriores, agora trabalhamos com:

- `DateTime`;
- datas sem horário (`DateTime(ano, mes, dia)`);
- comparação de datas;
- normalização automática de datas pelo Dart (dia `0`, mês `0`);
- `toIso8601String` e `DateTime.tryParse`;
- `showDatePicker`;
- `InputDecorator` e `InkWell`;
- internacionalização com `flutter_localizations`;
- `locale`, `supportedLocales` e `localizationsDelegates`;
- métodos `static`;
- métodos estáticos dentro de `enum`;
- migração de dados antigos salvos;
- filtro de listas com `where`;
- ordenação com `sort` e `compareTo`;
- agrupamento com `Map` e `putIfAbsent`;
- callbacks que recebem parâmetros (`void Function(Expense)`);
- botão desativado com `onPressed: null`;
- `onChanged` com `setState` para atualizar a tela enquanto se digita;
- separação entre "todos os dados" (`_expenses`) e "dados exibidos" (`_monthExpenses`).

---

# O que ainda NÃO vamos adicionar

```text
❌ Provider
❌ Riverpod
❌ BLoC
❌ GetX
❌ Firebase
❌ SQLite
❌ API
❌ Login
❌ Repository
❌ Dependency Injection
❌ Clean Architecture
❌ Pacote intl
```

O projeto continua usando:

```text
StatefulWidget
+
setState
+
LocalStorageService
```

---

# Próxima evolução possível — Fase 4

Depois que esta fase estiver funcionando, algumas evoluções naturais seriam:

1. metas diferentes para cada mês;
2. gráfico de gastos por categoria;
3. comparação entre o mês atual e o anterior;
4. busca e filtro por categoria no histórico;
5. exportar os gastos do mês.
