# Projeto: Orçamento Mensal em Flutter — Fase 2

## Persistência, edição e exclusão

Esta fase começa **depois que a Fase 1 estiver completamente funcionando**.

As funcionalidades que vamos adicionar são:

1. Persistência local;
2. Edição de metas;
3. Edição de gastos;
4. Exclusão de gastos.

---

# Como usar este roteiro

Este guia segue a mesma regra da Fase 1:

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

---

# O que muda nesta fase

Na Fase 1, os dados existiam apenas na memória:

```dart
final List<Expense> _expenses = [];
```

e:

```dart
final Map<ExpenseCategory, double> _goals = {
  for (final category in ExpenseCategory.values)
    category: 0.0,
};
```

Isso significa que, ao fechar completamente o aplicativo, todos os dados desapareciam.

Nesta fase vamos salvar essas informações no dispositivo.

Também vamos permitir:

```text
Gasto
 ├── criar
 ├── editar
 └── excluir

Meta
 ├── criar
 └── editar
```

---

# Como será feita a persistência

Vamos utilizar o pacote:

```text
shared_preferences
```

Ele permite armazenar valores simples no dispositivo.

Como nossas informações são um pouco mais complexas, vamos transformar os dados em texto JSON antes de salvá-los.

O fluxo será:

```text
List<Expense>
      ↓
   toJson()
      ↓
 jsonEncode()
      ↓
String
      ↓
shared_preferences
```

Na leitura faremos o processo contrário:

```text
shared_preferences
      ↓
String
      ↓
 jsonDecode()
      ↓
 fromJson()
      ↓
List<Expense>
```

Não vamos utilizar banco de dados nesta fase.

---

# Estrutura final da Fase 2

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
└── widgets/
    ├── expense_tile.dart
    ├── budget_summary_card.dart
    └── category_budget_card.dart
```

A única pasta nova será:

```text
services
```

---

# Etapa 1 — Adicionar o pacote de persistência

Abra o terminal na pasta do projeto.

Execute:

```bash
flutter pub add shared_preferences
```

Espere o comando terminar.

Depois execute:

```bash
flutter pub get
```

Não precisamos editar o `pubspec.yaml` manualmente.

## Checkpoint

- [ ] `flutter pub add shared_preferences` terminou sem erro.
- [ ] `flutter pub get` terminou sem erro.
- [ ] O aplicativo ainda executa com `flutter run`.
- [ ] Não existem erros vermelhos no projeto.

---

# Etapa 2 — Adicionar um ID aos gastos

Para editar ou excluir um gasto precisamos conseguir identificar exatamente qual gasto está sendo alterado.

Imagine dois gastos iguais:

```text
Uber
Transporte
€ 15,00
```

e:

```text
Uber
Transporte
€ 15,00
```

Se utilizarmos apenas título, categoria e valor, não temos uma forma confiável de saber qual deles deve ser alterado.

Por isso cada gasto passará a possuir um:

```text
id
```

Abra:

```text
lib/models/expense.dart
```

Apague todo o conteúdo e copie o arquivo completo:

```dart
import 'expense_category.dart';

class Expense {
  final String id;
  final String title;
  final ExpenseCategory category;
  final double amount;

  const Expense({
    required this.id,
    required this.title,
    required this.category,
    required this.amount,
  });

  Expense copyWith({
    String? id,
    String? title,
    ExpenseCategory? category,
    double? amount,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category.name,
      'amount': amount,
    };
  }

  factory Expense.fromJson(Map<String, dynamic> json) {
    final categoryName = json['category'] as String;

    final category = ExpenseCategory.values.firstWhere(
      (category) => category.name == categoryName,
      orElse: () => ExpenseCategory.restaurant,
    );

    return Expense(
      id: json['id'] as String,
      title: json['title'] as String,
      category: category,
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
```

## O que apareceu de novo

Agora temos:

```dart
final String id;
```

Também adicionamos:

```dart
toJson()
```

para transformar o gasto em dados que podem ser convertidos para JSON.

E:

```dart
Expense.fromJson()
```

para fazer o processo contrário.

Também criamos:

```dart
copyWith()
```

que será útil quando editarmos um gasto.

## Importante

Depois desta alteração, o projeto provavelmente mostrará erro em:

```text
add_expense_page.dart
```

Isso é esperado.

O motivo é que o construtor de `Expense` agora exige:

```dart
id:
```

Vamos corrigir isso na próxima etapa.

Não execute o aplicativo ainda.

---

# Etapa 3 — Preparar o formulário para criar e editar gastos

Vamos transformar o formulário que antes servia apenas para criar gastos.

Agora ele poderá receber um gasto existente.

O comportamento será:

```text
Sem gasto recebido
      ↓
Novo gasto

Com gasto recebido
      ↓
Editar gasto
```

Abra:

```text
lib/screens/add_expense_page.dart
```

Apague tudo.

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';

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
      text: expense == null
          ? ''
          : expense.amount.toStringAsFixed(2),
    );

    _selectedCategory = expense?.category;
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
            id: DateTime.now()
                .microsecondsSinceEpoch
                .toString(),
            title: _titleController.text.trim(),
            category: _selectedCategory!,
            amount: amount,
          )
        : existingExpense.copyWith(
            title: _titleController.text.trim(),
            category: _selectedCategory!,
            amount: amount,
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
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveExpense,
                  child: Text(
                    _isEditing
                        ? 'Salvar alterações'
                        : 'Adicionar gasto',
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

Antes tínhamos:

```dart
const AddExpensePage();
```

Agora podemos continuar usando isso para criar:

```dart
const AddExpensePage();
```

Mas também podemos editar:

```dart
AddExpensePage(
  expenseToEdit: expense,
);
```

Quando existe um gasto para editar, o formulário já será preenchido automaticamente.

## Checkpoint

Execute:

```bash
flutter run
```

Teste o cadastro normal.

Cadastre:

```text
Título: Pizza
Categoria: Restauração
Valor: 25
```

O gasto deve continuar sendo criado normalmente.

- [ ] O projeto compila.
- [ ] O cadastro abre.
- [ ] O cadastro continua funcionando.
- [ ] O gasto aparece no histórico.
- [ ] Não existem erros relacionados ao novo campo `id`.

---

# Etapa 4 — Criar o serviço de armazenamento local

Agora vamos criar uma classe responsável exclusivamente por salvar e carregar os dados.

Crie a pasta:

```text
lib/services
```

Dentro dela crie:

```text
lib/services/local_storage_service.dart
```

Copie o arquivo completo:

```dart
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';

class LocalStorageService {
  static const String _expensesKey = 'expenses';
  static const String _goalsKey = 'goals';

  final SharedPreferencesAsync _preferences =
      SharedPreferencesAsync();

  Future<void> saveExpenses(
    List<Expense> expenses,
  ) async {
    final expensesAsJson = expenses
        .map(
          (expense) => expense.toJson(),
        )
        .toList();

    final encodedExpenses = jsonEncode(
      expensesAsJson,
    );

    await _preferences.setString(
      _expensesKey,
      encodedExpenses,
    );
  }

  Future<List<Expense>> loadExpenses() async {
    final encodedExpenses = await _preferences.getString(
      _expensesKey,
    );

    if (encodedExpenses == null ||
        encodedExpenses.isEmpty) {
      return [];
    }

    try {
      final decodedExpenses = jsonDecode(
        encodedExpenses,
      ) as List<dynamic>;

      return decodedExpenses.map((item) {
        final map = Map<String, dynamic>.from(
          item as Map,
        );

        return Expense.fromJson(map);
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveGoals(
    Map<ExpenseCategory, double> goals,
  ) async {
    final goalsAsJson = {
      for (final category in ExpenseCategory.values)
        category.name: goals[category] ?? 0.0,
    };

    final encodedGoals = jsonEncode(
      goalsAsJson,
    );

    await _preferences.setString(
      _goalsKey,
      encodedGoals,
    );
  }

  Future<Map<ExpenseCategory, double>>
      loadGoals() async {
    final encodedGoals = await _preferences.getString(
      _goalsKey,
    );

    if (encodedGoals == null ||
        encodedGoals.isEmpty) {
      return {
        for (final category in ExpenseCategory.values)
          category: 0.0,
      };
    }

    try {
      final decodedGoals = Map<String, dynamic>.from(
        jsonDecode(encodedGoals) as Map,
      );

      return {
        for (final category in ExpenseCategory.values)
          category:
              (decodedGoals[category.name] as num?)
                      ?.toDouble() ??
                  0.0,
      };
    } catch (_) {
      return {
        for (final category in ExpenseCategory.values)
          category: 0.0,
      };
    }
  }
}
```

## O que esta classe faz

Ela possui quatro operações:

```dart
saveExpenses()
```

salva os gastos.

```dart
loadExpenses()
```

carrega os gastos.

```dart
saveGoals()
```

salva as metas.

```dart
loadGoals()
```

carrega as metas.

A Home não precisará saber como JSON ou `shared_preferences` funcionam.

Ela apenas chamará o serviço.

## Checkpoint

- [ ] A pasta `services` existe.
- [ ] `local_storage_service.dart` existe.
- [ ] Não existem erros vermelhos.
- [ ] O projeto continua compilando.

Ainda não estamos utilizando o serviço.

Isso será feito na próxima etapa.

---

# Etapa 5 — Salvar e carregar os dados automaticamente

Agora vamos conectar o serviço à Home.

Nesta primeira parte vamos implementar apenas:

- carregar gastos;
- carregar metas;
- salvar novos gastos;
- salvar metas editadas.

Ainda não vamos adicionar os botões de editar e excluir gastos.

Abra:

```text
lib/screens/home_page.dart
```

Apague tudo.

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../services/local_storage_service.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_budget_card.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_page.dart';
import 'budget_goals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorageService _storage =
      LocalStorageService();

  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category in ExpenseCategory.values)
      category: 0.0,
  };

  bool _isLoading = true;

  double get _totalSpent {
    return _expenses.fold(
      0,
      (total, expense) => total + expense.amount,
    );
  }

  double get _totalBudget {
    return _goals.values.fold(
      0,
      (total, goal) => total + goal,
    );
  }

  double spentByCategory(
    ExpenseCategory category,
  ) {
    return _expenses
        .where(
          (expense) => expense.category == category,
        )
        .fold(
          0,
          (total, expense) => total + expense.amount,
        );
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
    });

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _openBudgetGoals() async {
    final goals =
        await Navigator.push<
            Map<ExpenseCategory, double>
        >(
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento Mensal'),
        actions: [
          IconButton(
            onPressed: _isLoading
                ? null
                : _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: 'Definir metas',
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
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
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
                      (category) =>
                          CategoryBudgetCard(
                        category: category,
                        goal:
                            _goals[category] ?? 0,
                        spent: spentByCategory(
                          category,
                        ),
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
                    if (_expenses.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'Nenhuma transação cadastrada.',
                          ),
                        ),
                      )
                    else
                      ..._expenses.map(
                        (expense) => ExpenseTile(
                          expense: expense,
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

Ao abrir o aplicativo:

```dart
initState()
```

chama:

```dart
_loadData();
```

Enquanto os dados são carregados mostramos:

```dart
CircularProgressIndicator()
```

Quando um gasto é criado:

```dart
await _storage.saveExpenses(_expenses);
```

Quando uma meta é salva:

```dart
await _storage.saveGoals(_goals);
```

---

# Etapa 6 — Testar a persistência

Este checkpoint é muito importante.

## 1. Configure metas

Use:

```text
Restauração: 300
Transporte: 150
Roupas: 100
Educação: 200
Lazer: 150
```

## 2. Cadastre gastos

Cadastre:

```text
Pizza
Restauração
40
```

Depois:

```text
Uber
Transporte
20
```

## 3. Confira a tela

Você deve ver:

```text
Orçamento: € 900,00
Gasto:     € 60,00
Restante:  € 840,00
```

## 4. Feche completamente o aplicativo

Não faça apenas Hot Reload.

Feche realmente o aplicativo.

Depois execute novamente:

```bash
flutter run
```

## Resultado esperado

Os dados precisam continuar existindo:

```text
Restauração: € 300,00
Transporte:  € 150,00
Roupas:      € 100,00
Educação:    € 200,00
Lazer:       € 150,00
```

E no histórico:

```text
Pizza
Restauração
€ 40,00

Uber
Transporte
€ 20,00
```

## Checkpoint

- [ ] Metas sobrevivem ao fechamento do app.
- [ ] Gastos sobrevivem ao fechamento do app.
- [ ] O resumo continua correto.
- [ ] As categorias continuam corretas.
- [ ] Não existem erros ao abrir o app novamente.

Se esse checkpoint não funcionar, **não avance**.

---

# Etapa 7 — Edição de metas

Na Fase 1 a tela de metas já recebia os valores atuais.

Por isso a edição de metas praticamente já existe.

Agora, com a persistência, precisamos validar que ela funciona completamente.

Abra:

```text
lib/screens/budget_goals_page.dart
```

Substitua pelo arquivo completo abaixo para garantir que todos estejam usando a mesma implementação:

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
  State<BudgetGoalsPage> createState() =>
      _BudgetGoalsPageState();
}

class _BudgetGoalsPageState
    extends State<BudgetGoalsPage> {
  final _formKey = GlobalKey<FormState>();

  late final Map<
      ExpenseCategory,
      TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = {
      for (final category in ExpenseCategory.values)
        category: TextEditingController(
          text: (widget.currentGoals[category] ?? 0)
              .toStringAsFixed(2),
        ),
    };
  }

  void _saveGoals() {
    final isValid =
        _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final goals =
        <ExpenseCategory, double>{};

    for (final category
        in ExpenseCategory.values) {
      final text = _controllers[category]!
          .text
          .replaceAll(',', '.');

      goals[category] =
          double.parse(text);
    }

    Navigator.pop(context, goals);
  }

  @override
  void dispose() {
    for (final controller
        in _controllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas do mês'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Edite quanto pretende gastar em cada categoria.',
                ),
                const SizedBox(height: 24),
                ...ExpenseCategory.values.map(
                  (category) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 16,
                      ),
                      child: TextFormField(
                        controller:
                            _controllers[category],
                        keyboardType:
                            const TextInputType
                                .numberWithOptions(
                          decimal: true,
                        ),
                        decoration:
                            InputDecoration(
                          labelText:
                              category.label,
                          prefixText: '€ ',
                          border:
                              const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value
                                  .trim()
                                  .isEmpty) {
                            return 'Informe uma meta';
                          }

                          final goal =
                              double.tryParse(
                            value.replaceAll(
                              ',',
                              '.',
                            ),
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
                  },
                ),
                ElevatedButton(
                  onPressed: _saveGoals,
                  child: const Text(
                    'Salvar alterações',
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

## Teste

Suponha que Restauração esteja:

```text
€ 300,00
```

Abra as metas.

Altere para:

```text
€ 500,00
```

Salve.

O orçamento total deve aumentar em:

```text
€ 200,00
```

Feche completamente o aplicativo.

Abra novamente.

A meta deve continuar:

```text
Restauração: € 500,00
```

## Checkpoint

- [ ] A tela abre com os valores atuais preenchidos.
- [ ] É possível alterar uma meta.
- [ ] O resumo muda imediatamente.
- [ ] A barra da categoria muda.
- [ ] A alteração permanece após fechar o app.

---

# Etapa 8 — Adicionar ações ao histórico

Agora vamos adicionar duas ações para cada gasto:

```text
Editar
Excluir
```

Abra:

```text
lib/widgets/expense_tile.dart
```

Apague tudo.

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

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
                        Text('Editar'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete),
                        SizedBox(width: 8),
                        Text('Excluir'),
                      ],
                    ),
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
```

Neste momento a Home mostrará erros.

Isso é esperado porque agora `ExpenseTile` exige:

```dart
onEdit:
```

e:

```dart
onDelete:
```

Vamos corrigir a Home na próxima etapa.

---

# Etapa 9 — Implementar edição e exclusão de gastos

Agora chegamos à versão final da Home para esta fase.

Abra:

```text
lib/screens/home_page.dart
```

Apague todo o conteúdo.

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../services/local_storage_service.dart';
import '../widgets/budget_summary_card.dart';
import '../widgets/category_budget_card.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_page.dart';
import 'budget_goals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() =>
      _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LocalStorageService _storage =
      LocalStorageService();

  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category
        in ExpenseCategory.values)
      category: 0.0,
  };

  bool _isLoading = true;

  double get _totalSpent {
    return _expenses.fold(
      0,
      (total, expense) =>
          total + expense.amount,
    );
  }

  double get _totalBudget {
    return _goals.values.fold(
      0,
      (total, goal) => total + goal,
    );
  }

  double spentByCategory(
    ExpenseCategory category,
  ) {
    return _expenses
        .where(
          (expense) =>
              expense.category == category,
        )
        .fold(
          0,
          (total, expense) =>
              total + expense.amount,
        );
  }

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    final expenses =
        await _storage.loadExpenses();

    final goals =
        await _storage.loadGoals();

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
    final expense =
        await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const AddExpensePage(),
      ),
    );

    if (expense == null || !mounted) {
      return;
    }

    setState(() {
      _expenses.add(expense);
    });

    await _storage.saveExpenses(
      _expenses,
    );
  }

  Future<void> _editExpense(
    Expense expense,
  ) async {
    final updatedExpense =
        await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) =>
            AddExpensePage(
          expenseToEdit: expense,
        ),
      ),
    );

    if (updatedExpense == null ||
        !mounted) {
      return;
    }

    final index = _expenses.indexWhere(
      (item) =>
          item.id == updatedExpense.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _expenses[index] = updatedExpense;
    });

    await _storage.saveExpenses(
      _expenses,
    );
  }

  Future<void> _deleteExpense(
    Expense expense,
  ) async {
    final shouldDelete =
        await showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Excluir gasto',
                  ),
                  content: Text(
                    'Deseja realmente excluir "${expense.title}"?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          false,
                        );
                      },
                      child: const Text(
                        'Cancelar',
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          true,
                        );
                      },
                      child: const Text(
                        'Excluir',
                      ),
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
        (item) =>
            item.id == expense.id,
      );
    });

    await _storage.saveExpenses(
      _expenses,
    );
  }

  Future<void> _openBudgetGoals() async {
    final goals =
        await Navigator.push<
            Map<ExpenseCategory, double>
        >(
      context,
      MaterialPageRoute(
        builder: (context) =>
            BudgetGoalsPage(
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
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('Orçamento Mensal'),
        actions: [
          IconButton(
            onPressed: _isLoading
                ? null
                : _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: 'Editar metas',
          ),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child:
                    CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding:
                    const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.stretch,
                  children: [
                    BudgetSummaryCard(
                      budget: _totalBudget,
                      spent: _totalSpent,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Metas por categoria',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    ...ExpenseCategory.values
                        .map(
                      (category) =>
                          CategoryBudgetCard(
                        category: category,
                        goal:
                            _goals[category] ??
                                0,
                        spent:
                            spentByCategory(
                          category,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    const Text(
                      'Histórico de transações',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    if (_expenses.isEmpty)
                      const Card(
                        child: Padding(
                          padding:
                              EdgeInsets.all(
                            16,
                          ),
                          child: Text(
                            'Nenhuma transação cadastrada.',
                          ),
                        ),
                      )
                    else
                      ..._expenses.map(
                        (expense) =>
                            ExpenseTile(
                          expense: expense,
                          onEdit: () {
                            _editExpense(
                              expense,
                            );
                          },
                          onDelete: () {
                            _deleteExpense(
                              expense,
                            );
                          },
                        ),
                      ),
                    const SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton(
              onPressed: _openAddExpense,
              child:
                  const Icon(Icons.add),
            ),
    );
  }
}
```

Agora cada gasto possui um menu com:

```text
Editar
Excluir
```

---

# Etapa 10 — Testar a edição de gastos

Cadastre um gasto:

```text
Título: Uber
Categoria: Transporte
Valor: 15
```

No histórico, abra o menu do gasto.

Escolha:

```text
Editar
```

A tela deve abrir já preenchida:

```text
Título
Uber

Categoria
Transporte

Valor
15.00
```

Altere para:

```text
Título: Uber aeroporto
Categoria: Transporte
Valor: 25
```

Toque em:

```text
Salvar alterações
```

## Resultado esperado

O histórico deve mudar para:

```text
Uber aeroporto
Transporte
€ 25,00
```

O total do orçamento também precisa ser recalculado.

Feche o aplicativo completamente.

Abra novamente.

O gasto precisa continuar:

```text
Uber aeroporto
Transporte
€ 25,00
```

## Checkpoint

- [ ] O botão Editar abre o formulário.
- [ ] O formulário abre preenchido.
- [ ] O título pode ser alterado.
- [ ] A categoria pode ser alterada.
- [ ] O valor pode ser alterado.
- [ ] O resumo é atualizado.
- [ ] A categoria é atualizada.
- [ ] O histórico é atualizado.
- [ ] A alteração permanece após fechar o app.

---

# Etapa 11 — Testar mudança de categoria

Este teste é importante porque um gasto editado pode sair de uma categoria e entrar em outra.

Cadastre:

```text
Cinema
Lazer
€ 30
```

Observe o total de Lazer.

Agora edite o gasto para:

```text
Cinema
Restauração
€ 30
```

## Resultado esperado

O valor deve desaparecer do total de:

```text
Lazer
```

e passar para:

```text
Restauração
```

O total geral não deve mudar, porque o valor continua sendo:

```text
€ 30
```

## Checkpoint

- [ ] O valor foi retirado de Lazer.
- [ ] O valor foi adicionado em Restauração.
- [ ] O gasto total não mudou.
- [ ] A alteração persiste após reiniciar o app.

---

# Etapa 12 — Testar exclusão

Cadastre:

```text
Café
Restauração
€ 5
```

Abra o menu desse gasto.

Selecione:

```text
Excluir
```

Deve aparecer uma confirmação:

```text
Excluir gasto

Deseja realmente excluir "Café"?

Cancelar    Excluir
```

Primeiro toque em:

```text
Cancelar
```

O gasto deve continuar existindo.

Tente novamente.

Desta vez toque em:

```text
Excluir
```

O gasto deve desaparecer.

## Checkpoint

- [ ] Excluir mostra confirmação.
- [ ] Cancelar não remove o gasto.
- [ ] Excluir remove o gasto.
- [ ] O total gasto diminui.
- [ ] A categoria é recalculada.
- [ ] O gasto não volta após reiniciar o app.

---

# Etapa 13 — Teste completo da Fase 2

Agora faça um teste começando com o aplicativo funcionando normalmente.

## Metas

Configure:

```text
Restauração: € 300
Transporte:  € 150
Roupas:      € 100
Educação:    € 200
Lazer:       € 150
```

Total:

```text
€ 900
```

## Gastos

Cadastre:

```text
Pizza
Restauração
€ 40
```

```text
Uber
Transporte
€ 20
```

```text
Cinema
Lazer
€ 30
```

Total gasto:

```text
€ 90
```

Restante:

```text
€ 810
```

---

## Reiniciar

Feche o aplicativo.

Abra novamente.

Tudo deve continuar igual.

---

## Editar meta

Altere:

```text
Lazer
€ 150
```

para:

```text
Lazer
€ 250
```

O orçamento passa de:

```text
€ 900
```

para:

```text
€ 1000
```

---

## Editar gasto

Altere:

```text
Pizza
Restauração
€ 40
```

para:

```text
Jantar
Restauração
€ 60
```

O total gasto passa de:

```text
€ 90
```

para:

```text
€ 110
```

---

## Excluir gasto

Exclua:

```text
Uber
Transporte
€ 20
```

O total gasto passa de:

```text
€ 110
```

para:

```text
€ 90
```

---

## Reiniciar novamente

Feche o aplicativo.

Abra novamente.

O resultado deve continuar:

```text
Orçamento: € 1000
Gasto:     € 90
Restante:  € 910
```

No histórico:

```text
Jantar
Restauração
€ 60

Cinema
Lazer
€ 30
```

O gasto Uber não pode reaparecer.

---

# Checklist da Fase 2

## Persistência

- [ ] `shared_preferences` instalado.
- [ ] Gastos são salvos.
- [ ] Metas são salvas.
- [ ] Gastos são carregados ao abrir.
- [ ] Metas são carregadas ao abrir.
- [ ] Existe indicador de carregamento.
- [ ] Fechar o app não apaga os dados.

## Modelo Expense

- [ ] Possui `id`.
- [ ] Possui `toJson()`.
- [ ] Possui `fromJson()`.
- [ ] Possui `copyWith()`.

## Metas

- [ ] A tela abre com valores atuais.
- [ ] É possível editar uma meta.
- [ ] Alteração atualiza o resumo.
- [ ] Alteração atualiza a categoria.
- [ ] Alteração é persistida.

## Gastos

- [ ] É possível cadastrar.
- [ ] É possível editar.
- [ ] Formulário de edição abre preenchido.
- [ ] É possível alterar título.
- [ ] É possível alterar categoria.
- [ ] É possível alterar valor.
- [ ] Alterações são persistidas.

## Exclusão

- [ ] Existe opção Excluir.
- [ ] Existe confirmação.
- [ ] Cancelar mantém o gasto.
- [ ] Confirmar remove o gasto.
- [ ] Totais são recalculados.
- [ ] Exclusão é persistida.

---

# Arquivos alterados nesta fase

Ao terminar, estes arquivos terão sido modificados:

```text
lib/models/expense.dart

lib/screens/add_expense_page.dart

lib/screens/budget_goals_page.dart

lib/screens/home_page.dart

lib/widgets/expense_tile.dart
```

E este arquivo será novo:

```text
lib/services/local_storage_service.dart
```

Também será adicionada a dependência:

```text
shared_preferences
```

---

# O que foi aprendido nesta fase

Além do conteúdo da Fase 1, agora trabalhamos com:

- dependências externas;
- `shared_preferences`;
- persistência local;
- operações assíncronas com `Future`;
- `async` e `await`;
- `initState`;
- carregamento inicial;
- `CircularProgressIndicator`;
- JSON;
- `jsonEncode`;
- `jsonDecode`;
- serialização;
- desserialização;
- IDs;
- reutilização de formulário;
- edição de objetos;
- busca de item com `indexWhere`;
- exclusão com `removeWhere`;
- callbacks;
- `PopupMenuButton`;
- `AlertDialog`;
- confirmação antes de excluir;
- atualização da interface após edição;
- atualização da interface após exclusão;
- separação da persistência em um `service`.

---

# O que ainda NÃO vamos adicionar

Mesmo na Fase 2, não precisamos de:

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
```

Nosso projeto continua pequeno o suficiente para utilizar:

```text
StatefulWidget
+
setState
+
LocalStorageService
```

---

# Próxima evolução possível — Fase 3

Depois que esta fase estiver funcionando, uma evolução natural seria adicionar:

```text
Data do gasto
      ↓
Mês do gasto
      ↓
Histórico mensal
      ↓
Navegação entre meses
```

Isso permitiria transformar o aplicativo de um orçamento único em um orçamento mensal real, mantendo os meses anteriores salvos.

Uma possível Fase 3 poderia ter:

1. adicionar data ao gasto;
2. mostrar somente os gastos do mês selecionado;
3. navegar entre meses;
4. manter metas diferentes por mês;
5. visualizar histórico de meses anteriores.
