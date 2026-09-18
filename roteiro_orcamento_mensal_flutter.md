# Projeto: Orçamento Mensal em Flutter

Este guia foi pensado como um projeto **didático e incremental**, para que cada etapa possa ser implementada e validada antes de avançar.

Para a primeira versão, evite `Provider`, `Riverpod`, BLoC, banco de dados e outras dependências. O objetivo é praticar os fundamentos do Flutter usando `setState()` e estado em memória.

---

## Objetivo do aplicativo

O aplicativo será um orçamento mensal onde o usuário poderá:

- Definir uma meta de gastos para cada categoria;
- Cadastrar um gasto;
- Visualizar os gastos cadastrados;
- Visualizar quanto já foi gasto;
- Visualizar quanto ainda pode gastar;
- Saber se ultrapassou o orçamento;
- Saber quanto gastou por categoria.

### Categorias

- Restauração
- Transporte
- Roupas
- Educação
- Lazer

### Regras

Cada gasto deve possuir:

- Título
- Categoria
- Valor

Os lançamentos não precisam estar:

- Ordenados
- Filtrados

A meta total do mês será a soma das metas de todas as categorias.

Exemplo:

```text
Restauração: €300
Transporte:  €150
Roupas:      €100
Educação:    €200
Lazer:       €150
------------------
Orçamento:   €900
```

---

# Estrutura final do projeto

Ao terminar, o diretório `lib` deve ficar aproximadamente assim:

```text
lib/
│
├── main.dart
│
├── models/
│   ├── expense.dart
│   └── expense_category.dart
│
├── screens/
│   ├── home_page.dart
│   ├── add_expense_page.dart
│   └── budget_goals_page.dart
│
└── widgets/
    ├── budget_summary_card.dart
    ├── category_budget_card.dart
    └── expense_tile.dart
```

Não precisa criar tudo de uma vez.

A ideia é criar conforme avançamos.

---

# Etapa 1 — Criar o projeto

Criar o projeto:

```bash
flutter create monthly_budget
```

Entrar na pasta:

```bash
cd monthly_budget
```

Executar:

```bash
flutter run
```

Nesse momento, não precisa alterar nada.

## Checkpoint

Antes de continuar:

- [ ] O projeto compila.
- [ ] O aplicativo padrão do Flutter abre.
- [ ] O contador padrão funciona.
- [ ] Não existem erros no terminal.

Se isso estiver funcionando, pode apagar o código padrão.

---

# Etapa 2 — Criar as categorias

Criar:

```text
lib/models/expense_category.dart
```

A primeira tarefa é representar as cinco categorias.

Pode usar um `enum`:

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

Isso permite escrever:

```dart
ExpenseCategory.restaurant
```

e obter:

```dart
ExpenseCategory.restaurant.label
```

que retorna:

```text
Restauração
```

## O que está sendo praticado

- `enum`
- propriedades
- construtor
- modelagem de domínio

## Checkpoint

Faça temporariamente:

```dart
print(ExpenseCategory.restaurant.label);
```

O console deve mostrar:

```text
Restauração
```

---

# Etapa 3 — Criar o modelo de um gasto

Criar:

```text
lib/models/expense.dart
```

Cada gasto precisa ter exatamente os dados definidos nos requisitos:

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

Por enquanto não vamos adicionar:

```text
id
data
descrição
mês
usuário
```

porque não fazem parte do requisito.

Ela precisa conseguir criar algo assim:

```dart
final expense = Expense(
  title: 'Jantar',
  category: ExpenseCategory.restaurant,
  amount: 35.50,
);
```

## Checkpoint

Teste:

```dart
print(expense.title);
print(expense.category.label);
print(expense.amount);
```

Deve aparecer algo parecido com:

```text
Jantar
Restauração
35.5
```

---

# Etapa 4 — Preparar o `main.dart`

Editar:

```text
lib/main.dart
```

Pode começar assim:

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

Ainda não existe `HomePage`, então naturalmente o projeto dará erro até a próxima etapa.

---

# Etapa 5 — Criar a tela principal

Criar:

```text
lib/screens/home_page.dart
```

Essa será a tela mais importante do aplicativo.

Ela precisa ser um:

```dart
StatefulWidget
```

porque os gastos vão mudar enquanto o aplicativo estiver sendo utilizado.

Comece com:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';

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

Temos agora duas informações importantes.

`_expenses` guarda todos os gastos.

`_goals` guarda a meta para cada categoria.

Por exemplo:

```dart
_goals[ExpenseCategory.restaurant] = 300;
```

## Checkpoint

Ao executar:

```bash
flutter run
```

deve aparecer:

```text
Orçamento Mensal

Meu orçamento
```

Sem erros.

---

# Etapa 6 — Criar a tela de cadastro de gasto

Criar:

```text
lib/screens/add_expense_page.dart
```

A tela terá:

```text
Novo gasto

Título
[ Jantar com amigos ]

Categoria
[ Restauração      ▼ ]

Valor
[ 35,50 ]

[ Adicionar gasto ]
```

## Widgets que devem ser usados

```dart
Scaffold
AppBar
Form
TextFormField
DropdownButtonFormField
ElevatedButton
Column
Padding
SizedBox
```

Comece com:

```dart
class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}
```

Dentro do estado:

```dart
final _formKey = GlobalKey<FormState>();

final _titleController = TextEditingController();
final _amountController = TextEditingController();

ExpenseCategory? _selectedCategory;
```

---

# Etapa 7 — Campo de título

Dentro do `Form`, criar:

```dart
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
```

## Testar duas situações

Título vazio:

```text
Título vazio
```

deve dar erro.

Título preenchido:

```text
Supermercado
```

deve ser aceito.

## Checkpoint

- [ ] Existe um campo de título.
- [ ] O teclado aparece.
- [ ] Não aceita título vazio.
- [ ] A mensagem de erro aparece abaixo do campo.

---

# Etapa 8 — Campo de categoria

Adicionar um:

```dart
DropdownButtonFormField<ExpenseCategory>
```

Por exemplo:

```dart
DropdownButtonFormField<ExpenseCategory>(
  initialValue: _selectedCategory,
  decoration: const InputDecoration(
    labelText: 'Categoria',
    border: OutlineInputBorder(),
  ),
  items: ExpenseCategory.values.map((category) {
    return DropdownMenuItem(
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
```

## Checkpoint

O dropdown precisa mostrar exatamente:

```text
Restauração
Transporte
Roupas
Educação
Lazer
```

E não pode permitir salvar sem selecionar uma categoria.

---

# Etapa 9 — Campo do valor

Adicionar:

```dart
TextFormField(
  controller: _amountController,
  decoration: const InputDecoration(
    labelText: 'Valor',
    border: OutlineInputBorder(),
    prefixText: '€ ',
  ),
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
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
```

O:

```dart
replaceAll(',', '.')
```

permite digitar tanto:

```text
20.50
```

quanto:

```text
20,50
```

## Checkpoint

Deve funcionar:

```text
20
20.50
20,50
150,99
```

Não deve aceitar:

```text
abc
-30
0
```

---

# Etapa 10 — Salvar o gasto

O botão deverá validar o formulário:

```dart
ElevatedButton(
  onPressed: _saveExpense,
  child: const Text('Adicionar gasto'),
),
```

Criar:

```dart
void _saveExpense() {
  if (!_formKey.currentState!.validate()) {
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
```

A tela de cadastro não adiciona diretamente na lista.

Ela retorna um:

```dart
Expense
```

para a tela anterior.

Não esquecer de liberar os controllers:

```dart
@override
void dispose() {
  _titleController.dispose();
  _amountController.dispose();

  super.dispose();
}
```

---

# Etapa 11 — Abrir a tela pelo botão `+`

Voltar para:

```text
home_page.dart
```

Adicionar:

```dart
floatingActionButton: FloatingActionButton(
  onPressed: _openAddExpense,
  child: const Icon(Icons.add),
),
```

E criar:

```dart
Future<void> _openAddExpense() async {
  final expense = await Navigator.push<Expense>(
    context,
    MaterialPageRoute(
      builder: (_) => const AddExpensePage(),
    ),
  );

  if (expense == null) {
    return;
  }

  setState(() {
    _expenses.add(expense);
  });
}
```

Não esquecer:

```dart
import 'add_expense_page.dart';
```

## Checkpoint

Faça este fluxo:

```text
Home
 ↓
+
 ↓
Novo gasto
 ↓
Título: Uber
Categoria: Transporte
Valor: 15
 ↓
Adicionar
 ↓
Home
```

Depois disso:

```dart
_expenses.length
```

deve ser:

```text
1
```

Adicione outro.

Deve ser:

```text
2
```

---

# Etapa 12 — Mostrar o histórico

Criar:

```text
lib/widgets/expense_tile.dart
```

O objetivo é transformar um `Expense` em uma linha visual.

Pode usar:

```dart
ListTile
```

Uma representação simples:

```text
🍴 Jantar
   Restauração                €35,50
```

O widget receberá:

```dart
final Expense expense;
```

E pode utilizar:

```dart
ListTile(
  title: Text(expense.title),
  subtitle: Text(expense.category.label),
  trailing: Text(
    '€ ${expense.amount.toStringAsFixed(2)}',
  ),
)
```

Depois, na `HomePage`, mostrar:

```dart
if (_expenses.isEmpty)
  const Text('Nenhuma transação cadastrada')
else
  ..._expenses.map(
    (expense) => ExpenseTile(
      expense: expense,
    ),
  ),
```

Não precisa ordenar.

Isso atende ao requisito de que os lançamentos não precisam estar ordenados nem filtrados.

## Checkpoint

Adicione:

```text
Uber             Transporte   €12.00
Pizza            Restauração  €24.00
Cinema           Lazer        €10.00
Curso Flutter    Educação     €50.00
```

Eles devem aparecer na Home.

---

# Etapa 13 — Criar as metas por categoria

Criar:

```text
lib/screens/budget_goals_page.dart
```

A tela pode ser:

```text
Metas do mês

Restauração
[ € 300 ]

Transporte
[ € 150 ]

Roupas
[ € 100 ]

Educação
[ € 200 ]

Lazer
[ € 150 ]

[ Salvar metas ]
```

Essa página recebe:

```dart
final Map<ExpenseCategory, double> currentGoals;
```

Algo como:

```dart
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
```

---

# Etapa 14 — Controllers para as metas

Como temos cinco categorias, podemos criar um controller para cada uma:

```dart
late final Map<
  ExpenseCategory,
  TextEditingController
> _controllers;
```

No `initState()`:

```dart
@override
void initState() {
  super.initState();

  _controllers = {
    for (final category in ExpenseCategory.values)
      category: TextEditingController(
        text: widget.currentGoals[category]
                ?.toStringAsFixed(2) ??
            '0.00',
      ),
  };
}
```

No `dispose()`:

```dart
@override
void dispose() {
  for (final controller in _controllers.values) {
    controller.dispose();
  }

  super.dispose();
}
```

---

# Etapa 15 — Construir os campos dinamicamente

Em vez de criar cinco `TextFormField` manualmente:

```dart
...ExpenseCategory.values.map(
  (category) {
    return TextFormField(
      controller: _controllers[category],
      decoration: InputDecoration(
        labelText: category.label,
        prefixText: '€ ',
        border: const OutlineInputBorder(),
      ),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
      ),
    );
  },
),
```

Aqui o objetivo é entender que os widgets podem ser criados a partir dos dados.

---

# Etapa 16 — Retornar as metas

Quando clicar em salvar, monte um novo mapa:

```dart
final goals = <ExpenseCategory, double>{};

for (final category in ExpenseCategory.values) {
  final text = _controllers[category]!
      .text
      .replaceAll(',', '.');

  goals[category] = double.tryParse(text) ?? 0;
}
```

Depois:

```dart
Navigator.pop(context, goals);
```

---

# Etapa 17 — Abrir as metas pela Home

Na `AppBar` da Home:

```dart
actions: [
  IconButton(
    onPressed: _openBudgetGoals,
    icon: const Icon(Icons.tune),
  ),
],
```

Criar:

```dart
Future<void> _openBudgetGoals() async {
  final goals =
      await Navigator.push<Map<ExpenseCategory, double>>(
    context,
    MaterialPageRoute(
      builder: (_) => BudgetGoalsPage(
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
```

## Checkpoint

Configure:

```text
Restauração  €300
Transporte   €150
Roupas       €100
Educação     €200
Lazer        €150
```

Feche e abra novamente a tela de metas.

Os valores precisam continuar aparecendo enquanto o app estiver aberto.

---

# Etapa 18 — Calcular quanto foi gasto

Na `HomePage`:

```dart
double get _totalSpent {
  return _expenses.fold(
    0,
    (total, expense) => total + expense.amount,
  );
}
```

Por exemplo:

```text
Pizza       €30
Uber        €20
Cinema      €15
```

Resultado:

```text
_totalSpent = €65
```

## Checkpoint

Cadastre:

```text
€10
€25
€40
```

O resultado precisa ser:

```text
€75
```

---

# Etapa 19 — Calcular o orçamento disponível

A meta total é:

```dart
double get _totalBudget {
  return _goals.values.fold(
    0,
    (total, goal) => total + goal,
  );
}
```

Se as metas forem:

```text
300
150
100
200
150
```

deve retornar:

```text
900
```

---

# Etapa 20 — Calcular saldo

Criar:

```dart
double get _balance {
  return _totalBudget - _totalSpent;
}
```

Exemplo:

```text
Orçamento: €900
Gastos:    €650
```

Resultado:

```text
€250
```

Então mostrar:

```text
Você ainda pode gastar €250.
```

Outro exemplo:

```text
Orçamento: €900
Gastos:    €1050
```

Resultado:

```text
-€150
```

Então mostrar:

```text
Você ultrapassou o orçamento em €150.
```

---

# Etapa 21 — Criar o card resumo

Criar:

```text
lib/widgets/budget_summary_card.dart
```

A ideia é chegar a algo parecido com:

```text
┌──────────────────────────────────┐
│ Orçamento mensal                 │
│                                  │
│ €900,00                          │
│                                  │
│ Gasto             €650,00        │
│ Restante           €250,00       │
│                                  │
│ ✓ Dentro do orçamento            │
└──────────────────────────────────┘
```

Ou:

```text
┌──────────────────────────────────┐
│ Orçamento mensal                 │
│                                  │
│ €900,00                          │
│                                  │
│ Gasto            €1050,00        │
│ Excedido           €150,00       │
│                                  │
│ ⚠ Orçamento ultrapassado         │
└──────────────────────────────────┘
```

Widgets sugeridos:

```dart
Card
Padding
Column
Row
Text
Icon
```

O componente pode receber:

```dart
final double budget;
final double spent;
```

e calcular:

```dart
final balance = budget - spent;
```

---

# Etapa 22 — Gastos por categoria

Criar esta função na Home:

```dart
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
```

Imagine:

```text
Pizza        Restauração   €30
Restaurante  Restauração   €50
Uber         Transporte    €20
Cinema       Lazer         €15
```

Então:

```dart
spentByCategory(
  ExpenseCategory.restaurant,
)
```

deve retornar:

```text
80
```

---

# Etapa 23 — Criar card das categorias

Criar:

```text
lib/widgets/category_budget_card.dart
```

Queremos chegar a:

```text
Restauração

€180 de €300

████████████░░░░░░░░ 60%
```

Ela vai praticar:

```dart
LinearProgressIndicator
```

Cálculo:

```dart
final progress = goal > 0
    ? spent / goal
    : 0.0;
```

Como o valor pode passar de `1`, faça:

```dart
final progress = goal > 0
    ? (spent / goal).clamp(0.0, 1.0).toDouble()
    : 0.0;
```

E:

```dart
LinearProgressIndicator(
  value: progress,
),
```

---

# Etapa 24 — Exibir todas as categorias

Na Home:

```dart
...ExpenseCategory.values.map(
  (category) {
    return CategoryBudgetCard(
      category: category,
      goal: _goals[category] ?? 0,
      spent: spentByCategory(category),
    );
  },
),
```

Resultado:

```text
Restauração
€250 / €300
████████████████░░

Transporte
€70 / €150
████████░░░░░░░░░░

Roupas
€100 / €100
██████████████████

Educação
€250 / €200
██████████████████

Lazer
€40 / €150
████░░░░░░░░░░░░░░
```

---

# Etapa 25 — Organização final da Home

A tela pode seguir esta ordem:

```text
ORÇAMENTO MENSAL
────────────────────────

Orçamento
€900

Gasto
€650

Restante
€250

✓ Dentro do orçamento


METAS POR CATEGORIA

Restauração
€200 / €300
████████████░░░░

Transporte
€100 / €150
██████████░░░░░░

...


HISTÓRICO

Pizza
Restauração                   €30

Uber
Transporte                    €20

Cinema
Lazer                         €15


                         [ + ]
```

Não precisa tentar deixar bonito antes de tudo funcionar.

Regra recomendada:

> **Primeiro funcional. Depois visual.**

---

# Etapa 26 — Cenário completo de teste

## 1. Configure metas

```text
Restauração   €300
Transporte    €150
Roupas        €100
Educação      €200
Lazer         €150
```

Total esperado:

```text
€900
```

## 2. Cadastre

```text
Pizza
Restauração
€40
```

Depois:

```text
Uber
Transporte
€20
```

Depois:

```text
Cinema
Lazer
€30
```

Total gasto:

```text
€90
```

Saldo esperado:

```text
€810
```

## 3. Confira categorias

Esperado:

```text
Restauração
€40 / €300

Transporte
€20 / €150

Roupas
€0 / €100

Educação
€0 / €200

Lazer
€30 / €150
```

## Checkpoint

Se todos esses valores aparecerem corretamente, praticamente todas as regras da aplicação estão funcionando.

---

# Etapa 27 — Teste de orçamento ultrapassado

Agora cadastre:

```text
MacBook
Educação
€1000
```

Total gasto:

```text
€1090
```

Orçamento:

```text
€900
```

O aplicativo precisa mostrar:

```text
Orçamento ultrapassado

€190 acima do orçamento
```

## Checkpoint

Não deve mostrar:

```text
Restante: -€190
```

Apesar de matematicamente correto, isso é pior para o usuário.

Prefira:

```dart
if (_balance >= 0) {
  // restante
} else {
  // excedido
}
```

E mostrar:

```dart
_balance.abs()
```

quando ultrapassado.

---

# Etapa 28 — Casos que precisam ser testados

| Situação | Resultado esperado |
|---|---|
| Título vazio | Mostrar erro |
| Categoria vazia | Mostrar erro |
| Valor vazio | Mostrar erro |
| Valor `abc` | Mostrar erro |
| Valor `0` | Mostrar erro |
| Valor negativo | Mostrar erro |
| Valor `12,50` | Aceitar |
| Valor `12.50` | Aceitar |
| Apertar voltar no cadastro | Não cadastrar |
| Cadastrar dois gastos iguais | Aceitar |
| Não existir nenhum gasto | Mostrar empty state |
| Meta = €0 | Não quebrar progress bar |
| Gasto maior que a meta | Mostrar que ultrapassou |

---

# O que NÃO colocar nessa primeira versão

Evite deliberadamente:

```text
❌ Riverpod
❌ Provider
❌ BLoC
❌ GetX
❌ Clean Architecture
❌ Repository
❌ UseCases
❌ Dependency Injection
❌ API
❌ Firebase
❌ SQLite
❌ Login
```

Não porque essas ferramentas sejam ruins, mas porque elas não ajudam a aprender o objetivo desta primeira versão.

Esse projeto já ensina:

```text
Model
 ↓
State
 ↓
UI
 ↓
Form
 ↓
Validation
 ↓
Navigation
 ↓
Return value
 ↓
setState
 ↓
List rendering
 ↓
Business rules
 ↓
Componentização
```

---

# Histórico não persistente

Com esta implementação:

```dart
final List<Expense> _expenses = [];
```

o histórico existe **enquanto o aplicativo estiver executando**.

Se fechar o aplicativo completamente:

```text
expenses = []
```

novamente.

Isso é proposital nesta primeira versão.

Depois de terminar o projeto funcionando, uma segunda fase natural seria:

```text
Fase 1
UI + lógica + estado em memória
        ↓
Fase 2
Persistência local
        ↓
Fase 3
Histórico de vários meses
```

Na Fase 2 ela poderia aprender armazenamento local sem misturar esse assunto com formulários e estado logo no início.

---

# Checklist final de implementação

## Parte 1 — Modelagem

- [ ] Criar projeto.
- [ ] Criar `ExpenseCategory`.
- [ ] Criar `Expense`.
- [ ] Criar `HomePage`.

## Parte 2 — Cadastro

- [ ] Criar `AddExpensePage`.
- [ ] Criar campo título.
- [ ] Criar dropdown de categoria.
- [ ] Criar campo valor.
- [ ] Validar formulário.
- [ ] Criar `Expense`.
- [ ] Retornar `Expense` com `Navigator.pop`.
- [ ] Receber resultado na Home.
- [ ] Adicionar na lista usando `setState`.

## Parte 3 — Histórico

- [ ] Criar `ExpenseTile`.
- [ ] Mostrar lista de gastos.
- [ ] Criar mensagem quando a lista estiver vazia.

## Parte 4 — Orçamento

- [ ] Criar `BudgetGoalsPage`.
- [ ] Criar uma meta para cada categoria.
- [ ] Salvar metas.
- [ ] Calcular meta total.
- [ ] Calcular gasto total.
- [ ] Calcular saldo.
- [ ] Identificar orçamento ultrapassado.

## Parte 5 — Dashboard

- [ ] Criar `BudgetSummaryCard`.
- [ ] Mostrar orçamento.
- [ ] Mostrar total gasto.
- [ ] Mostrar restante ou excedente.
- [ ] Calcular gastos por categoria.
- [ ] Criar `CategoryBudgetCard`.
- [ ] Adicionar `LinearProgressIndicator`.

## Parte 6 — Finalização

- [ ] Testar formulário inválido.
- [ ] Testar orçamento zerado.
- [ ] Testar orçamento ultrapassado.
- [ ] Testar várias transações.
- [ ] Melhorar espaçamento.
- [ ] Melhorar cores.
- [ ] Remover códigos de teste e `print()`.

---

# Objetivo pedagógico

Ao terminar este projeto, ela terá praticado:

- `StatelessWidget`
- `StatefulWidget`
- `setState`
- Models
- Enums
- `Form`
- `TextFormField`
- Validação
- `TextEditingController`
- Dropdowns
- `ListTile`
- Listas dinâmicas
- `Navigator`
- Retorno de valores entre páginas
- Composição de widgets
- Regras de negócio
- Componentização

A persistência fica propositalmente fora dessa primeira entrega.

Depois que essa versão estiver pronta, o próximo exercício natural é fazer os gastos e metas sobreviverem ao fechamento do app e, em seguida, adicionar mês/data para transformar o histórico atual em um histórico mensal real.
