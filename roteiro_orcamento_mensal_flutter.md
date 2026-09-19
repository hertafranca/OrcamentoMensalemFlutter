# Projeto: Orçamento Mensal em Flutter

## Como usar este roteiro

Este roteiro foi feito para alguém que está começando em Flutter e **não precisa saber completar código por conta própria**.

A regra durante todo o exercício será:

> Quando o roteiro disser **"crie este arquivo"** ou **"substitua o conteúdo deste arquivo"**, copie exatamente o código completo apresentado.

Sempre que um arquivo precisar mudar, o roteiro mostrará **o arquivo inteiro novamente**. Assim, não é necessário descobrir sozinho onde colocar um método, um widget, um `import` ou uma variável.

Outra regra importante:

> **Não avance para a próxima etapa se o checkpoint atual não estiver funcionando.**

A ideia é montar o aplicativo como um LEGO: uma peça por vez, mantendo o projeto funcionando antes de adicionar a próxima.

---

# O aplicativo

O aplicativo será um orçamento mensal onde o usuário poderá:

- cadastrar gastos;
- visualizar o histórico de gastos;
- definir uma meta de gasto para cada categoria;
- visualizar quanto já gastou;
- visualizar quanto ainda pode gastar;
- saber se ultrapassou o orçamento;
- visualizar o gasto de cada categoria.

## Categorias

1. Restauração;
2. Transporte;
3. Roupas;
4. Educação;
5. Lazer.

## Dados obrigatórios de um gasto

Cada gasto precisa ter:

- título;
- categoria;
- valor.

Os lançamentos **não precisam estar ordenados nem filtrados**.

---

# Estrutura final

Ao terminar, teremos esta estrutura dentro de `lib`:

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
└── widgets/
    ├── expense_tile.dart
    ├── budget_summary_card.dart
    └── category_budget_card.dart
```

Não crie tudo agora. Vamos criar cada arquivo no momento correto.

---

# Etapa 1 — Criar o projeto

No terminal:

```bash
flutter create monthly_budget
```

Entre na pasta:

```bash
cd monthly_budget
```

Execute:

```bash
flutter run
```

## Checkpoint

- [ ] O projeto foi criado.
- [ ] `flutter run` funciona.
- [ ] O aplicativo padrão aparece.
- [ ] Não existem erros vermelhos no terminal.

---

# Etapa 2 — Criar a primeira tela

Crie a pasta:

```text
lib/screens
```

Crie o arquivo:

```text
lib/screens/home_page.dart
```

Copie **todo** o código:

```dart
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento Mensal'),
      ),
      body: const Center(
        child: Text('Meu orçamento'),
      ),
    );
  }
}
```

Agora abra:

```text
lib/main.dart
```

Apague tudo e coloque:

```dart
import 'package:flutter/material.dart';

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

## Checkpoint

Na tela deve aparecer:

```text
Orçamento Mensal

Meu orçamento
```

- [ ] A AppBar aparece.
- [ ] O texto aparece.
- [ ] O app continua compilando.

---

# Etapa 3 — Criar as categorias

Crie a pasta:

```text
lib/models
```

Crie:

```text
lib/models/expense_category.dart
```

Copie o arquivo completo:

```dart
enum ExpenseCategory {
  restaurant('Restauração'),
  transport('Transporte'),
  clothes('Roupas'),
  education('Educação'),
  leisure('Lazer');

  final String label;

  const ExpenseCategory(this.label);
}
```

## Checkpoint

- [ ] O arquivo existe.
- [ ] Não existem erros vermelhos.
- [ ] O app continua funcionando.

---

# Etapa 4 — Criar o modelo de gasto

Crie:

```text
lib/models/expense.dart
```

Copie o arquivo completo:

```dart
import 'expense_category.dart';

class Expense {
  final String title;
  final ExpenseCategory category;
  final double amount;

  const Expense({
    required this.title,
    required this.category,
    required this.amount,
  });
}
```

Um gasto agora pode ser representado assim:

```dart
Expense(
  title: 'Jantar',
  category: ExpenseCategory.restaurant,
  amount: 35.50,
)
```

## Checkpoint

- [ ] `expense.dart` existe.
- [ ] `expense_category.dart` existe.
- [ ] Não existem erros.

---

# Etapa 5 — Criar a tela completa de cadastro

Crie:

```text
lib/screens/add_expense_page.dart
```

Copie **o arquivo inteiro**:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  ExpenseCategory? _selectedCategory;

  void _saveExpense() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final amount = double.parse(
      _amountController.text.replaceAll(',', '.'),
    );

    final expense = Expense(
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
        title: const Text('Novo gasto'),
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
                  child: const Text('Adicionar gasto'),
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

Nesta etapa a tela está completa, mas ainda não existe um botão para abri-la. Isso é normal.

## Checkpoint

- [ ] `add_expense_page.dart` existe.
- [ ] O componente está completo, inclusive o método `build`.
- [ ] Não existem erros vermelhos.
- [ ] O projeto continua compilando.

---

# Etapa 6 — Criar o componente visual de um gasto

Crie a pasta:

```text
lib/widgets
```

Crie:

```text
lib/widgets/expense_tile.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;

  const ExpenseTile({
    super.key,
    required this.expense,
  });

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(expense.title),
        subtitle: Text(expense.category.label),
        trailing: Text(
          _formatMoney(expense.amount),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
```

## Checkpoint

- [ ] `expense_tile.dart` existe.
- [ ] Não existem erros.
- [ ] O app continua compilando.

---

# Etapa 7 — Fazer a Home cadastrar e mostrar gastos

Abra:

```text
lib/screens/home_page.dart
```

Apague **todo** o conteúdo atual e substitua por:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _expenses = [];

  Future<void> _openAddExpense() async {
    final expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpensePage(),
      ),
    );

    if (expense == null) {
      return;
    }

    setState(() {
      _expenses.add(expense);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento Mensal'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _expenses.isEmpty
              ? const Center(
                  child: Text('Nenhuma transação cadastrada.'),
                )
              : ListView.builder(
                  itemCount: _expenses.length,
                  itemBuilder: (context, index) {
                    final expense = _expenses[index];

                    return ExpenseTile(
                      expense: expense,
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Teste

Toque em `+` e cadastre:

```text
Título: Uber
Categoria: Transporte
Valor: 15
```

Ao tocar em `Adicionar gasto`, deve voltar para a Home e mostrar:

```text
Uber
Transporte                         € 15,00
```

## Checkpoint

- [ ] O botão `+` abre o cadastro.
- [ ] O formulário aparece completo.
- [ ] Título vazio mostra erro.
- [ ] Categoria vazia mostra erro.
- [ ] Valor inválido mostra erro.
- [ ] Ao salvar, volta para a Home.
- [ ] O gasto aparece na lista.
- [ ] É possível cadastrar vários gastos.

---

# Etapa 8 — Criar a tela completa de metas

Crie:

```text
lib/screens/budget_goals_page.dart
```

Copie o arquivo completo:

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
        title: const Text('Metas do mês'),
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
                  'Informe quanto pretende gastar em cada categoria.',
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

## Checkpoint

- [ ] A tela está completa.
- [ ] Existem os cinco campos no código.
- [ ] Não existem erros.

---

# Etapa 9 — Adicionar metas e resumo à Home

Abra:

```text
lib/screens/home_page.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../widgets/expense_tile.dart';
import 'add_expense_page.dart';
import 'budget_goals_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category in ExpenseCategory.values)
      category: 0.0,
  };

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

  double get _balance {
    return _totalBudget - _totalSpent;
  }

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Future<void> _openAddExpense() async {
    final expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpensePage(),
      ),
    );

    if (expense == null) {
      return;
    }

    setState(() {
      _expenses.add(expense);
    });
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

    if (goals == null) {
      return;
    }

    setState(() {
      _goals
        ..clear()
        ..addAll(goals);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOverBudget = _balance < 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento Mensal'),
        actions: [
          IconButton(
            onPressed: _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: 'Definir metas',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Resumo do mês',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Orçamento: ${_formatMoney(_totalBudget)}'),
                      const SizedBox(height: 8),
                      Text('Gasto: ${_formatMoney(_totalSpent)}'),
                      const SizedBox(height: 8),
                      if (isOverBudget)
                        Text(
                          'Excedido: ${_formatMoney(_balance.abs())}',
                        )
                      else
                        Text(
                          'Restante: ${_formatMoney(_balance)}',
                        ),
                    ],
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
                    child: Text('Nenhuma transação cadastrada.'),
                  ),
                )
              else
                ..._expenses.map(
                  (expense) => ExpenseTile(
                    expense: expense,
                  ),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Teste das metas

Abra o botão de ajustes no canto superior direito e configure:

```text
Restauração: 300
Transporte: 150
Roupas: 100
Educação: 200
Lazer: 150
```

Toque em `Salvar metas`.

O orçamento total deve mostrar:

```text
€ 900,00
```

## Checkpoint

- [ ] O botão de ajustes abre a tela de metas.
- [ ] Existem cinco campos.
- [ ] É possível salvar.
- [ ] O total das metas aparece na Home.
- [ ] Os gastos cadastrados continuam aparecendo.

---

# Etapa 10 — Criar o card de resumo

Crie:

```text
lib/widgets/budget_summary_card.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

class BudgetSummaryCard extends StatelessWidget {
  final double budget;
  final double spent;

  const BudgetSummaryCard({
    super.key,
    required this.budget,
    required this.spent,
  });

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final balance = budget - spent;
    final isOverBudget = balance < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Resumo do mês',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text('Orçamento: ${_formatMoney(budget)}'),
            const SizedBox(height: 8),
            Text('Gasto: ${_formatMoney(spent)}'),
            const SizedBox(height: 8),
            if (isOverBudget)
              Text(
                'Excedido: ${_formatMoney(balance.abs())}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )
            else
              Text(
                'Restante: ${_formatMoney(balance)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 16),
            if (budget == 0 && spent == 0)
              const Text('Defina as metas do mês para começar.')
            else if (isOverBudget)
              const Text('Orçamento ultrapassado.')
            else
              const Text('Você está dentro do orçamento.'),
          ],
        ),
      ),
    );
  }
}
```

## Checkpoint

- [ ] O arquivo existe.
- [ ] Não existem erros.

---

# Etapa 11 — Criar o card de categoria

Crie:

```text
lib/widgets/category_budget_card.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense_category.dart';

class CategoryBudgetCard extends StatelessWidget {
  final ExpenseCategory category;
  final double goal;
  final double spent;

  const CategoryBudgetCard({
    super.key,
    required this.category,
    required this.goal,
    required this.spent,
  });

  String _formatMoney(double value) {
    return '€ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final progress = goal > 0
        ? (spent / goal).clamp(0.0, 1.0).toDouble()
        : 0.0;

    final difference = goal - spent;
    final isOverGoal = difference < 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              category.label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${_formatMoney(spent)} de ${_formatMoney(goal)}',
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progress,
            ),
            const SizedBox(height: 8),
            if (goal == 0)
              const Text('Meta não definida.')
            else if (isOverGoal)
              Text(
                'Meta excedida em ${_formatMoney(difference.abs())}.',
              )
            else
              Text(
                'Ainda pode gastar ${_formatMoney(difference)}.',
              ),
          ],
        ),
      ),
    );
  }
}
```

## Checkpoint

- [ ] O arquivo existe.
- [ ] Não existem erros.

---

# Etapa 12 — Montar a Home final

Abra:

```text
lib/screens/home_page.dart
```

Apague tudo e copie **o arquivo completo**:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
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
  final List<Expense> _expenses = [];

  final Map<ExpenseCategory, double> _goals = {
    for (final category in ExpenseCategory.values)
      category: 0.0,
  };

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

  double spentByCategory(ExpenseCategory category) {
    return _expenses
        .where(
          (expense) => expense.category == category,
        )
        .fold(
          0,
          (total, expense) => total + expense.amount,
        );
  }

  Future<void> _openAddExpense() async {
    final expense = await Navigator.push<Expense>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpensePage(),
      ),
    );

    if (expense == null) {
      return;
    }

    setState(() {
      _expenses.add(expense);
    });
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

    if (goals == null) {
      return;
    }

    setState(() {
      _goals
        ..clear()
        ..addAll(goals);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento Mensal'),
        actions: [
          IconButton(
            onPressed: _openBudgetGoals,
            icon: const Icon(Icons.tune),
            tooltip: 'Definir metas',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              if (_expenses.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Nenhuma transação cadastrada.'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openAddExpense,
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

Agora todas as peças criadas anteriormente foram ligadas.

## Checkpoint

- [ ] A Home abre sem erros.
- [ ] O resumo aparece.
- [ ] As cinco categorias aparecem.
- [ ] Cada categoria possui uma barra de progresso.
- [ ] O histórico aparece.
- [ ] O botão `+` continua funcionando.
- [ ] O botão de metas continua funcionando.

---

# Etapa 13 — Teste completo

## 1. Configure as metas

```text
Restauração: €300
Transporte: €150
Roupas: €100
Educação: €200
Lazer: €150
```

Total esperado:

```text
€ 900,00
```

## 2. Cadastre Pizza

```text
Título: Pizza
Categoria: Restauração
Valor: 40
```

## 3. Cadastre Uber

```text
Título: Uber
Categoria: Transporte
Valor: 20
```

## 4. Cadastre Cinema

```text
Título: Cinema
Categoria: Lazer
Valor: 30
```

## Resultado esperado

```text
Orçamento: € 900,00
Gasto:     € 90,00
Restante:  € 810,00
```

Categorias:

```text
Restauração
€ 40,00 de € 300,00

Transporte
€ 20,00 de € 150,00

Roupas
€ 0,00 de € 100,00

Educação
€ 0,00 de € 200,00

Lazer
€ 30,00 de € 150,00
```

## Checkpoint

- [ ] Orçamento = `€ 900,00`.
- [ ] Gasto = `€ 90,00`.
- [ ] Restante = `€ 810,00`.
- [ ] Pizza aparece no histórico.
- [ ] Uber aparece no histórico.
- [ ] Cinema aparece no histórico.
- [ ] Os valores por categoria estão corretos.

---

# Etapa 14 — Testar orçamento ultrapassado

Adicione:

```text
Título: Curso
Categoria: Educação
Valor: 1000
```

Agora:

```text
Total gasto: € 1090,00
Orçamento:   € 900,00
```

O resumo deve mostrar:

```text
Excedido: € 190,00
Orçamento ultrapassado.
```

Educação deve mostrar:

```text
€ 1000,00 de € 200,00
Meta excedida em € 800,00.
```

## Checkpoint

- [ ] Não aparece `Restante: -€ 190,00`.
- [ ] Aparece `Excedido: € 190,00`.
- [ ] Educação informa que a meta foi excedida.

---

# Etapa 15 — Testes de formulário

Cadastro de gasto:

| Teste | Resultado esperado |
|---|---|
| Título vazio | Mostrar `Informe um título` |
| Categoria vazia | Mostrar `Selecione uma categoria` |
| Valor vazio | Mostrar `Informe o valor` |
| Valor `abc` | Mostrar `Informe um valor válido` |
| Valor `0` | Mostrar `O valor deve ser maior que zero` |
| Valor `-10` | Mostrar erro |
| Valor `12,50` | Aceitar |
| Valor `12.50` | Aceitar |
| Voltar sem salvar | Não criar gasto |
| Criar dois gastos iguais | Aceitar |

Metas:

| Teste | Resultado esperado |
|---|---|
| Meta vazia | Mostrar erro |
| Meta `abc` | Mostrar erro |
| Meta negativa | Mostrar erro |
| Meta `0` | Aceitar |
| Meta `100,50` | Aceitar |
| Meta `100.50` | Aceitar |

---

# Resultado visual esperado

A tela principal ficará aproximadamente assim:

```text
ORÇAMENTO MENSAL                         ⚙

┌──────────────────────────────────────┐
│ Resumo do mês                        │
│ Orçamento: € 900,00                  │
│ Gasto:     € 90,00                   │
│ Restante:  € 810,00                  │
│ Você está dentro do orçamento.       │
└──────────────────────────────────────┘

METAS POR CATEGORIA

┌──────────────────────────────────────┐
│ Restauração                          │
│ € 40,00 de € 300,00                  │
│ ███░░░░░░░░░░░░░░░                  │
│ Ainda pode gastar € 260,00.          │
└──────────────────────────────────────┘

...

HISTÓRICO DE TRANSAÇÕES

┌──────────────────────────────────────┐
│ Pizza                     € 40,00    │
│ Restauração                          │
└──────────────────────────────────────┘

┌──────────────────────────────────────┐
│ Uber                      € 20,00    │
│ Transporte                           │
└──────────────────────────────────────┘

                                   [ + ]
```

---

# O que NÃO adicionar nesta primeira versão

Não adicione:

- Provider;
- Riverpod;
- BLoC;
- GetX;
- Clean Architecture;
- Repository;
- Use Cases;
- Dependency Injection;
- Firebase;
- SQLite;
- API;
- Login.

Nesta primeira versão queremos praticar apenas:

```text
Model
  ↓
Widget
  ↓
State
  ↓
Form
  ↓
Validação
  ↓
Navigator
  ↓
Lista
  ↓
Cálculos
  ↓
Interface
```

---

# Importante — Os dados ainda não são salvos

Os gastos estão armazenados em memória:

```dart
final List<Expense> _expenses = [];
```

As metas também:

```dart
final Map<ExpenseCategory, double> _goals = {
  for (final category in ExpenseCategory.values)
    category: 0.0,
};
```

Se fechar completamente o aplicativo e abrir novamente, os dados serão perdidos.

Isso é proposital nesta primeira versão.

---

# Próxima fase possível

Depois que esta versão estiver funcionando:

```text
FASE 1 — atual
Interface + formulários + estado em memória

                ↓

FASE 2
Salvar gastos e metas localmente

                ↓

FASE 3
Adicionar data aos gastos

                ↓

FASE 4
Criar histórico por mês
```

---

# Checklist final

## Projeto

- [ ] O projeto abre sem erros.
- [ ] A Home aparece.
- [ ] Não existem erros vermelhos.

## Gastos

- [ ] É possível abrir o cadastro.
- [ ] É possível preencher título.
- [ ] É possível escolher categoria.
- [ ] É possível informar valor.
- [ ] As validações funcionam.
- [ ] É possível salvar.
- [ ] O gasto aparece na Home.

## Histórico

- [ ] Todos os gastos aparecem.
- [ ] O título aparece.
- [ ] A categoria aparece.
- [ ] O valor aparece.

## Metas

- [ ] Restauração possui meta.
- [ ] Transporte possui meta.
- [ ] Roupas possui meta.
- [ ] Educação possui meta.
- [ ] Lazer possui meta.
- [ ] Todas podem ser alteradas.

## Resumo

- [ ] O orçamento total é calculado.
- [ ] O total gasto é calculado.
- [ ] O restante é calculado.
- [ ] O excedente é calculado.
- [ ] O app informa quando o orçamento foi ultrapassado.

## Categorias

- [ ] Cada categoria mostra sua meta.
- [ ] Cada categoria mostra quanto foi gasto.
- [ ] Cada categoria possui barra de progresso.
- [ ] O app mostra quanto ainda pode gastar.
- [ ] O app informa quando a meta foi ultrapassada.

---

# O que foi aprendido

Ao terminar o projeto, terão sido usados:

- `MaterialApp`;
- `Scaffold`;
- `AppBar`;
- `StatelessWidget`;
- `StatefulWidget`;
- `setState`;
- `enum`;
- classes/modelos;
- `List`;
- `Map`;
- `Form`;
- `TextFormField`;
- `DropdownButtonFormField`;
- `TextEditingController`;
- validação;
- `ElevatedButton`;
- `FloatingActionButton`;
- `Navigator.push`;
- `Navigator.pop`;
- `ListTile`;
- `Card`;
- `Column`;
- `Padding`;
- `SizedBox`;
- `SingleChildScrollView`;
- `LinearProgressIndicator`;
- criação e reutilização de widgets;
- cálculos a partir de listas;
- organização de arquivos.

O ponto principal deste roteiro é que **nenhuma etapa exige completar um componente por conta própria**. Cada arquivo necessário aparece completo no momento em que deve ser criado ou substituído.
