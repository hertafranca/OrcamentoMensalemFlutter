# Projeto: Orçamento Mensal em Flutter — Fase 4

## Identidade visual e experiência de app de verdade

Esta fase começa **depois que a Fase 3 estiver completamente funcionando**.

Nesta fase **não vamos criar funcionalidades novas de orçamento**. Vamos transformar a aparência e o comportamento do aplicativo para que ele pareça e funcione como um app profissional.

As mudanças são:

1. Tema escuro com a paleta **Luxo & Mistério** (verde garrafa, roxo imperial e dourado);
2. Tipografia elegante: uma fonte com serifa para títulos e valores, e uma fonte limpa para textos;
3. Ícones para cada categoria;
4. Novo card de resumo com o valor disponível em destaque;
5. Cards de categoria com cores que indicam a situação (ok, atenção, estourado);
6. Formulário de gasto mais rápido: valor em destaque, categorias em botões e atalhos `Hoje` / `Ontem`;
7. Tela de metas mais simples: campo vazio significa "sem meta";
8. Tocar no gasto para editar e deslizar para excluir, com opção de **Desfazer**;
9. Mensagens de confirmação depois de salvar;
10. Telas vazias com orientação do que fazer;
11. Valores com separador de milhar (`€ 1.300,00`).

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

Em algumas etapas o roteiro vai avisar que **o projeto ficará com erro de propósito**, ou que **não deve ser executado ainda**. Quando isso acontecer, apenas siga para a próxima etapa.

---

# A identidade visual

## A paleta

```text
🟢 Verde Garrafa Profundo   #063B2E   → Abundância • Prosperidade • Poder
🟣 Roxo Imperial Profundo   #260033   → Mistério • Luxo • Profundidade
🟡 Dourado Rico             #C49A28   → Riqueza • Prestígio • Abundância
```

## Como cada cor será usada

| Cor | Onde aparece |
|---|---|
| Roxo Imperial `#260033` | Cartões (cards) e base do aplicativo |
| Roxo mais escuro `#16001E` | Fundo das telas |
| Verde Garrafa `#063B2E` | Card de resumo, botões de mês, categoria selecionada |
| Dourado `#C49A28` | Botão principal, valores importantes, ícones, títulos de seção |

## Por que existem cores extras?

As três cores da paleta são **fechadas e profundas**. Isso é ótimo para criar a identidade, mas um aplicativo também precisa de:

- texto legível sobre fundo escuro;
- cores que indiquem situação (dentro da meta, atenção, estourou).

O verde garrafa, por exemplo, é escuro demais para ser lido sobre o roxo. Por isso criamos tons derivados que combinam com a paleta:

| Cor | Uso |
|---|---|
| Creme `#F4EDE0` | Texto principal |
| Lilás acinzentado `#B9A9C6` | Texto secundário |
| Esmeralda `#4FB38A` | Dentro da meta |
| Dourado `#C49A28` | Atenção (acima de 80% da meta) |
| Rubi `#E5737A` | Meta ou orçamento ultrapassado |

Todas essas combinações têm contraste suficiente para leitura, seguindo as recomendações de acessibilidade.

## Tipografia

| Fonte | Onde | Por quê |
|---|---|---|
| **Playfair Display** | Títulos e valores em destaque | Fonte com serifa, transmite sofisticação |
| **Inter** | Textos, botões, campos | Fonte limpa, fácil de ler em tela pequena |

---

# Boas práticas de UX aplicadas nesta fase

Vale ler antes de começar, para entender o motivo de cada mudança.

| Prática | Como aparece no app |
|---|---|
| **Hierarquia visual**: o mais importante aparece maior | O valor disponível no mês é o maior número da tela |
| **Cores com significado** | Verde = ok, dourado = atenção, rubi = estourou |
| **Não usar só cor para comunicar** | Além da cor, sempre existe um texto (`Restam €...`, `Excedeu €...`) |
| **Menos toques** | Categorias em botões (1 toque) em vez de lista suspensa (2 toques); atalhos `Hoje` e `Ontem` |
| **Prevenir erros** | O campo de valor não aceita letras |
| **Desfazer em vez de perguntar** | Excluir é imediato, com botão `Desfazer` |
| **Feedback** | Mensagem curta depois de salvar, editar ou excluir |
| **Estados vazios úteis** | Tela vazia explica o que fazer e oferece um botão |
| **Consistência** | Cores e fontes definidas em um único lugar (o tema) |
| **Áreas de toque grandes** | Botões com pelo menos 48 pixels de altura |

---

# Estrutura final da Fase 4

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
├── theme/
│   ├── app_colors.dart
│   ├── app_theme.dart
│   └── category_icons.dart
├── utils/
│   ├── date_formatter.dart
│   └── money_formatter.dart
└── widgets/
    ├── budget_summary_card.dart
    ├── category_avatar.dart
    ├── category_budget_card.dart
    ├── empty_state.dart
    ├── expense_day_group.dart
    ├── expense_tile.dart
    ├── month_selector.dart
    └── section_title.dart
```

Novidades:

```text
theme/app_colors.dart          (novo)
theme/app_theme.dart           (novo)
theme/category_icons.dart      (novo)
utils/money_formatter.dart     (novo)
widgets/category_avatar.dart   (novo)
widgets/empty_state.dart       (novo)
widgets/section_title.dart     (novo)
```

Os arquivos de `models` e `services` **não mudam**. Os dados salvos continuam os mesmos.

---

# Etapa 1 — Adicionar o pacote de fontes

Vamos usar o pacote `google_fonts`, que baixa as fontes Playfair Display e Inter automaticamente.

Pare o aplicativo, se estiver rodando.

No terminal, na pasta do projeto, execute:

```bash
flutter pub add google_fonts
```

Depois:

```bash
flutter pub get
```

## Importante

Na primeira vez que o app abrir, as fontes são baixadas da internet e ficam guardadas no aparelho. Por isso o emulador ou celular precisa ter internet na primeira execução.

Sem internet, o app funciona normalmente, mas usa a fonte padrão.

## Checkpoint

Como o `pubspec.yaml` mudou, **não use Hot Reload**. Execute:

```bash
flutter run
```

- [ ] `flutter pub add google_fonts` terminou sem erro.
- [ ] O aplicativo abre normalmente.
- [ ] Não existem erros vermelhos.

Visualmente nada muda ainda.

---

# Etapa 2 — Criar a paleta de cores

Crie a pasta:

```text
lib/theme
```

Crie o arquivo:

```text
lib/theme/app_colors.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

class AppColors {
  // Paleta principal — Luxo & Mistério
  static const Color bottleGreen = Color(0xFF063B2E);
  static const Color imperialPurple = Color(0xFF260033);
  static const Color richGold = Color(0xFFC49A28);

  // Variações do dourado
  static const Color goldLight = Color(0xFFE2C46A);
  static const Color goldDark = Color(0xFF3A2C08);

  // Fundo e superfícies
  static const Color background = Color(0xFF16001E);
  static const Color surface = imperialPurple;
  static const Color surfaceHigh = Color(0xFF34114A);
  static const Color border = Color(0xFF4A2A5C);

  // Texto
  static const Color textPrimary = Color(0xFFF4EDE0);
  static const Color textSecondary = Color(0xFFB9A9C6);

  // Situações
  static const Color success = Color(0xFF4FB38A);
  static const Color warning = richGold;
  static const Color danger = Color(0xFFE5737A);
}
```

## O que esta classe faz

Ela guarda **todas as cores do aplicativo em um único lugar**.

No Flutter, uma cor é escrita assim:

```dart
Color(0xFF063B2E)
```

- `0x` indica que é um número hexadecimal;
- `FF` é a opacidade (totalmente visível);
- `063B2E` é o HEX da cor.

Se um dia quiser trocar uma cor, basta mudar aqui, e o app inteiro muda junto.

## Checkpoint

- [ ] A pasta `theme` existe.
- [ ] `app_colors.dart` existe.
- [ ] Não existem erros vermelhos.

---

# Etapa 3 — Criar o tema do aplicativo

O tema diz ao Flutter quais cores e fontes usar em **todos** os componentes (botões, cards, campos, calendário...).

Crie o arquivo:

```text
lib/theme/app_theme.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTheme {
  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.richGold,
      onPrimary: AppColors.imperialPurple,
      primaryContainer: AppColors.goldDark,
      onPrimaryContainer: AppColors.goldLight,
      secondary: AppColors.bottleGreen,
      onSecondary: AppColors.textPrimary,
      secondaryContainer: AppColors.bottleGreen,
      onSecondaryContainer: AppColors.textPrimary,
      error: AppColors.danger,
      onError: AppColors.imperialPurple,
      surface: AppColors.background,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerLowest: AppColors.background,
      surfaceContainerLow: AppColors.surface,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceHigh,
      surfaceContainerHighest: AppColors.surfaceHigh,
      outline: AppColors.border,
      outlineVariant: AppColors.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      textTheme: _textTheme(),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.richGold,
        foregroundColor: AppColors.imperialPurple,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.surfaceHigh,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        actionTextColor: AppColors.richGold,
        closeIconColor: AppColors.textSecondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
      ),
    );
  }

  // Playfair Display para títulos e valores.
  // Inter para todo o resto.
  static TextTheme _textTheme() {
    final baseTextTheme = ThemeData(brightness: Brightness.dark).textTheme;

    final bodyTextTheme = GoogleFonts.interTextTheme(baseTextTheme);
    final titleTextTheme = GoogleFonts.playfairDisplayTextTheme(baseTextTheme);

    return bodyTextTheme
        .copyWith(
          displayLarge: titleTextTheme.displayLarge,
          displayMedium: titleTextTheme.displayMedium,
          displaySmall: titleTextTheme.displaySmall,
          headlineLarge: titleTextTheme.headlineLarge,
          headlineMedium: titleTextTheme.headlineMedium,
          headlineSmall: titleTextTheme.headlineSmall,
          titleLarge: titleTextTheme.titleLarge,
        )
        .apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        );
  }

  // Aparência padrão dos campos de texto do app.
  static InputDecoration input({
    required String label,
    String? hintText,
    String? prefixText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hintText,
      prefixText: prefixText,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
      ),
    );
  }
}
```

## O que esta classe faz

### `ColorScheme`

É o "mapa" de cores do Material Design. Cada componente do Flutter sabe qual papel usar:

```text
primary      → dourado   → botão principal, item selecionado no calendário
onPrimary    → roxo      → texto que fica em cima do dourado
secondaryContainer → verde → categoria selecionada, botões de mês
surface      → fundo das telas
onSurface    → texto principal (creme)
error        → rubi      → mensagens de erro
```

### `textTheme`

Define as fontes. O Flutter tem tamanhos com nomes:

```text
displaySmall    → números grandes (Playfair)
headlineSmall   → mês selecionado (Playfair)
titleLarge      → títulos de seção e AppBar (Playfair)
titleMedium     → nomes de categoria (Inter)
bodyMedium      → textos comuns (Inter)
labelSmall      → rótulos pequenos (Inter)
```

Nos próximos arquivos, em vez de escrever `fontSize: 20`, vamos usar esses nomes. Assim o app fica consistente.

### `input()`

Um método que devolve a aparência padrão dos campos. Em vez de repetir bordas e cores em todo campo, escrevemos:

```dart
decoration: AppTheme.input(label: 'Descrição'),
```

## Checkpoint

- [ ] `app_theme.dart` existe.
- [ ] Não existem erros vermelhos.

Ainda não estamos usando o tema.

---

# Etapa 4 — Aplicar o tema

Abra:

```text
lib/main.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/home_page.dart';
import 'theme/app_theme.dart';

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
      theme: AppTheme.dark(),
      home: const HomePage(),
    );
  }
}
```

## O que mudou

Antes:

```dart
theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
  ),
  useMaterial3: true,
),
```

Agora:

```dart
theme: AppTheme.dark(),
```

## Checkpoint

Pare o aplicativo e execute novamente:

```bash
flutter run
```

Mesmo sem mudar nenhuma tela, o app já deve estar diferente:

- [ ] O fundo está roxo bem escuro.
- [ ] Os cards estão roxos, com cantos arredondados e uma borda fina.
- [ ] O título `Orçamento Mensal` está com fonte de serifa (Playfair).
- [ ] O botão `+` está dourado, com ícone roxo.
- [ ] As barras de progresso estão douradas.
- [ ] Ao abrir o calendário no cadastro, o dia selecionado aparece em dourado.
- [ ] Os textos estão legíveis (creme sobre roxo).

As telas ainda têm o layout antigo. Vamos redesenhar uma peça por vez.

---

# Etapa 5 — Formatar dinheiro e criar os ícones das categorias

## 5.1 Formatador de dinheiro

Até agora cada arquivo tinha sua própria função `_formatMoney`. Além de repetida, ela mostrava `€ 1300,00`, sem separador de milhar.

Crie o arquivo:

```text
lib/utils/money_formatter.dart
```

Copie o arquivo completo:

```dart
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
```

### Como funciona o separador de milhar

Para `1300`, os dígitos são `1 3 0 0`:

```text
escreve 1  → faltam 3 dígitos → 3 é múltiplo de 3 → escreve "."
escreve 3  → faltam 2
escreve 0  → faltam 1
escreve 0  → faltam 0
resultado: 1.300
```

`~/` é a divisão inteira do Dart: `130050 ~/ 100 = 1300`.

`%` é o resto da divisão: `130050 % 100 = 50`.

## 5.2 Ícones das categorias

Crie o arquivo:

```text
lib/theme/category_icons.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense_category.dart';

extension ExpenseCategoryIcon on ExpenseCategory {
  IconData get icon {
    return switch (this) {
      ExpenseCategory.food => Icons.restaurant_rounded,
      ExpenseCategory.transport => Icons.directions_car_rounded,
      ExpenseCategory.leisure => Icons.local_activity_rounded,
      ExpenseCategory.shopping => Icons.shopping_bag_rounded,
      ExpenseCategory.home => Icons.home_rounded,
      ExpenseCategory.education => Icons.school_rounded,
      ExpenseCategory.other => Icons.more_horiz_rounded,
    };
  }
}
```

### O que é uma `extension`

Uma `extension` adiciona algo novo a uma classe que já existe, **sem alterar o arquivo original**.

Depois de importar este arquivo, podemos escrever:

```dart
ExpenseCategory.food.icon
```

Por que não colocar o ícone direto no `enum`? Porque o `enum` é um **modelo de dados**. O ícone é um detalhe **visual**. Separar os dois é uma boa prática: se um dia o app mudar de visual, o modelo não precisa mudar.

## Checkpoint

- [ ] `money_formatter.dart` existe dentro de `utils`.
- [ ] `category_icons.dart` existe dentro de `theme`.
- [ ] Não existem erros vermelhos.

---

# Etapa 6 — Criar componentes reutilizáveis

Vamos criar três peças pequenas que serão usadas em várias telas.

## 6.1 Ícone redondo da categoria

Crie:

```text
lib/widgets/category_avatar.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../theme/category_icons.dart';

class CategoryAvatar extends StatelessWidget {
  final ExpenseCategory category;
  final double size;

  const CategoryAvatar({
    super.key,
    required this.category,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.richGold.withValues(alpha: 0.4),
        ),
      ),
      child: Icon(
        category.icon,
        color: AppColors.richGold,
        size: size * 0.5,
      ),
    );
  }
}
```

## 6.2 Título de seção

Crie:

```text
lib/widgets/section_title.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(top: 28, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4,
                height: 22,
                decoration: BoxDecoration(
                  color: AppColors.richGold,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleLarge,
                ),
              ),
            ],
          ),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(left: 14, top: 4),
              child: Text(
                subtitle!,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

## 6.3 Estado vazio

Quando uma lista está vazia, um app profissional não mostra só "nada". Ele explica a situação e, se possível, oferece um botão para resolver.

Crie:

```text
lib/widgets/empty_state.dart
```

Copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 28,
        ),
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.surfaceHigh,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColors.richGold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

## Detalhes novos

```dart
color.withValues(alpha: 0.4)
```

Cria a mesma cor com 40% de opacidade (um pouco transparente).

```dart
if (actionLabel != null && onAction != null) ...[
  ...
],
```

O `...[ ]` permite colocar **vários widgets** dentro de um único `if`.

## Checkpoint

- [ ] `category_avatar.dart` existe.
- [ ] `section_title.dart` existe.
- [ ] `empty_state.dart` existe.
- [ ] Não existem erros vermelhos.

Ainda não estamos usando esses componentes.

---

# Etapa 7 — Novo card de resumo

O resumo é a parte mais importante da tela. A pergunta que o usuário quer responder ao abrir o app é:

> **"Quanto ainda posso gastar este mês?"**

Por isso esse valor será o maior número da tela.

Abra:

```text
lib/widgets/budget_summary_card.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/money_formatter.dart';

class BudgetSummaryCard extends StatelessWidget {
  final double budget;
  final double spent;

  const BudgetSummaryCard({
    super.key,
    required this.budget,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final hasBudget = budget > 0;
    final balance = budget - spent;
    final isOverBudget = hasBudget && balance < 0;
    final ratio = hasBudget ? spent / budget : 0.0;
    final percent = (ratio * 100).round();

    final String label;
    final double mainValue;
    final Color mainColor;
    final IconData statusIcon;
    final Color statusColor;
    final String statusText;

    if (!hasBudget) {
      label = 'Gasto no mês';
      mainValue = spent;
      mainColor = AppColors.textPrimary;
      statusIcon = Icons.info_outline_rounded;
      statusColor = AppColors.textSecondary;
      statusText = 'Defina suas metas para acompanhar o orçamento.';
    } else if (isOverBudget) {
      label = 'Acima do orçamento';
      mainValue = balance.abs();
      mainColor = AppColors.danger;
      statusIcon = Icons.warning_amber_rounded;
      statusColor = AppColors.danger;
      statusText = 'Você ultrapassou o orçamento deste mês.';
    } else if (ratio >= 0.8) {
      label = 'Disponível para gastar';
      mainValue = balance;
      mainColor = AppColors.richGold;
      statusIcon = Icons.error_outline_rounded;
      statusColor = AppColors.warning;
      statusText = 'Atenção: você já usou $percent% do orçamento.';
    } else {
      label = 'Disponível para gastar';
      mainValue = balance;
      mainColor = AppColors.richGold;
      statusIcon = Icons.check_circle_outline_rounded;
      statusColor = AppColors.success;
      statusText = 'Tudo sob controle: você usou $percent% do orçamento.';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.bottleGreen,
            AppColors.imperialPurple,
          ],
        ),
        border: Border.all(
          color: AppColors.richGold.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              MoneyFormatter.format(mainValue),
              style: textTheme.displaySmall?.copyWith(
                color: mainColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          if (hasBudget) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: ratio.clamp(0.0, 1.0).toDouble(),
                minHeight: 8,
                color: statusColor,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
              ),
            ),
            const SizedBox(height: 16),
          ],
          Row(
            children: [
              Expanded(
                child: _SummaryValue(
                  label: 'Gasto',
                  value: spent,
                ),
              ),
              Expanded(
                child: _SummaryValue(
                  label: 'Orçamento',
                  value: budget,
                  alignEnd: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  statusIcon,
                  color: statusColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    statusText,
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  final String label;
  final double value;
  final bool alignEnd;

  const _SummaryValue({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment:
          alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          MoneyFormatter.format(value),
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
```

## O que mudou

O card agora tem quatro situações:

| Situação | Número grande | Mensagem |
|---|---|---|
| Sem metas | Gasto do mês (creme) | Defina suas metas... |
| Até 79% usado | Disponível (dourado) | Tudo sob controle (ícone esmeralda) |
| 80% a 100% usado | Disponível (dourado) | Atenção (ícone dourado) |
| Acima de 100% | Excedente (rubi) | Você ultrapassou... (ícone rubi) |

Novidades de código:

```dart
LinearGradient
```

Faz o fundo passar do verde garrafa para o roxo imperial.

```dart
FittedBox(fit: BoxFit.scaleDown, ...)
```

Se o valor for muito grande para a largura da tela, o texto diminui em vez de quebrar a tela.

```dart
class _SummaryValue
```

Um widget pequeno usado só dentro deste arquivo. O `_` no início do nome faz com que ele seja **privado** (outros arquivos não enxergam).

Repare que o construtor continua o mesmo (`budget` e `spent`). Por isso a Home não precisa mudar agora.

## Checkpoint

- [ ] O resumo aparece com fundo em degradê verde → roxo.
- [ ] O valor disponível aparece grande, em dourado e com fonte Playfair.
- [ ] Os valores têm separador de milhar (exemplo: `€ 1.235,00`).
- [ ] Aparecem `Gasto` e `Orçamento` lado a lado.
- [ ] Aparece a mensagem de situação com ícone.

---

# Etapa 8 — Novo card de categoria

Abra:

```text
lib/widgets/category_budget_card.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../utils/money_formatter.dart';
import 'category_avatar.dart';

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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final hasGoal = goal > 0;
    final ratio = hasGoal ? spent / goal : 0.0;
    final difference = goal - spent;

    final Color statusColor;
    final String statusText;

    if (!hasGoal) {
      statusColor = AppColors.textSecondary;
      statusText = 'Sem meta definida';
    } else if (ratio > 1) {
      statusColor = AppColors.danger;
      statusText = 'Excedeu ${MoneyFormatter.format(difference.abs())}';
    } else if (ratio >= 0.8) {
      statusColor = AppColors.warning;
      statusText = 'Restam ${MoneyFormatter.format(difference)}';
    } else {
      statusColor = AppColors.success;
      statusText = 'Restam ${MoneyFormatter.format(difference)}';
    }

    final percentText = hasGoal ? '${(ratio * 100).round()}%' : '—';

    final amountText = hasGoal
        ? '${MoneyFormatter.format(spent)} de ${MoneyFormatter.format(goal)}'
        : MoneyFormatter.format(spent);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CategoryAvatar(
                  category: category,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.label,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        amountText,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  percentText,
                  style: textTheme.titleMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: hasGoal ? ratio.clamp(0.0, 1.0).toDouble() : 0.0,
                minHeight: 6,
                color: statusColor,
                backgroundColor: AppColors.surfaceHigh,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              statusText,
              style: textTheme.bodySmall?.copyWith(
                color: statusColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## O que mudou

Cada card agora tem:

```text
[ícone]  Alimentação                    18%
         € 53,00 de € 300,00
████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
Restam € 247,00
```

A cor da porcentagem, da barra e do texto muda conforme a situação:

```text
até 79%     → esmeralda
80% a 100%  → dourado
acima       → rubi
```

O texto sempre acompanha a cor. Isso é importante para quem tem dificuldade de distinguir cores.

## Checkpoint

- [ ] Cada categoria tem seu ícone dourado em um círculo.
- [ ] A porcentagem aparece à direita.
- [ ] Categorias com meta mostram `€ X de € Y`.
- [ ] Categorias sem meta mostram `Sem meta definida` e `—`.
- [ ] As cores mudam conforme o consumo.

---

# Etapa 9 — Novo seletor de mês

Abra:

```text
lib/widgets/month_selector.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';

class MonthSelector extends StatelessWidget {
  final DateTime selectedMonth;
  final VoidCallback onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onCurrentMonth;

  const MonthSelector({
    super.key,
    required this.selectedMonth,
    required this.onPrevious,
    required this.onNext,
    this.onCurrentMonth,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              onPressed: onPrevious,
              icon: const Icon(Icons.chevron_left_rounded),
              tooltip: 'Mês anterior',
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    'MÊS SELECIONADO',
                    style: textTheme.labelSmall?.copyWith(
                      color: AppColors.textSecondary,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    DateFormatter.monthAndYear(selectedMonth),
                    textAlign: TextAlign.center,
                    style: textTheme.headlineSmall,
                  ),
                ],
              ),
            ),
            IconButton.filledTonal(
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right_rounded),
              tooltip: 'Próximo mês',
            ),
          ],
        ),
        if (onCurrentMonth != null)
          TextButton.icon(
            onPressed: onCurrentMonth,
            icon: const Icon(
              Icons.today_rounded,
              size: 18,
            ),
            label: const Text('Voltar para o mês atual'),
          ),
      ],
    );
  }
}
```

## O que mudou

O seletor saiu de dentro de um card e virou um cabeçalho. As setas agora são botões redondos verdes:

```dart
IconButton.filledTonal(...)
```

Também ganhou um novo parâmetro **opcional**:

```dart
final VoidCallback? onCurrentMonth;
```

Quando ele for informado, aparece o botão `Voltar para o mês atual`. Como ele não é `required`, a Home atual continua funcionando sem ele. Vamos usá-lo na Etapa 14.

## Checkpoint

- [ ] O mês aparece em fonte Playfair, centralizado.
- [ ] Acima do mês aparece `MÊS SELECIONADO`.
- [ ] As setas são botões redondos verdes.
- [ ] No mês atual, a seta da direita aparece desativada.
- [ ] As setas continuam trocando o mês.

---

# Etapa 10 — Novo formulário de gasto

Mudanças nesta tela:

- **Valor primeiro e em destaque**: é a informação principal de um gasto;
- **Categorias em botões com ícone**: um toque em vez de abrir uma lista;
- **Atalhos de data**: `Hoje` e `Ontem` resolvem a maioria dos casos sem abrir o calendário;
- **Campo de valor só aceita números**, vírgula e ponto;
- **Erros desaparecem enquanto o usuário corrige**.

Abra:

```text
lib/screens/add_expense_page.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/expense.dart';
import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/category_icons.dart';
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

  // Fica true depois da primeira tentativa de salvar.
  // A partir daí, os erros são atualizados enquanto o usuário digita.
  bool _triedToSave = false;

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
          : expense.amount.toStringAsFixed(2).replaceAll('.', ','),
    );

    _selectedCategory = expense?.category;

    _selectedDate = expense?.date ?? DateFormatter.onlyDate(DateTime.now());
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
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

    _selectDate(DateFormatter.onlyDate(pickedDate));
  }

  void _saveExpense() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      setState(() {
        _triedToSave = true;
      });

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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final amountStyle = textTheme.displaySmall?.copyWith(
      color: AppColors.richGold,
      fontWeight: FontWeight.w700,
    );

    final sectionStyle = textTheme.labelLarge?.copyWith(
      color: AppColors.textSecondary,
      letterSpacing: 1.2,
    );

    final today = DateFormatter.onlyDate(DateTime.now());
    final yesterday = DateTime(today.year, today.month, today.day - 1);
    final isToday = DateFormatter.isSameDay(_selectedDate, today);
    final isYesterday = DateFormatter.isSameDay(_selectedDate, yesterday);
    final isOtherDate = !isToday && !isYesterday;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Editar gasto' : 'Novo gasto',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: _triedToSave
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text('VALOR', style: sectionStyle),
              TextFormField(
                controller: _amountController,
                autofocus: !_isEditing,
                style: amountStyle,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixText: '€ ',
                  prefixStyle: amountStyle,
                  hintText: '0,00',
                  hintStyle: amountStyle?.copyWith(
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  border: const UnderlineInputBorder(),
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
              const SizedBox(height: 28),
              Text('DESCRIÇÃO', style: sectionStyle),
              const SizedBox(height: 10),
              TextFormField(
                controller: _titleController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                decoration: AppTheme.input(
                  label: 'Descrição',
                  hintText: 'Ex.: Mercado, Uber, Cinema',
                  prefixIcon: const Icon(Icons.notes_rounded),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe uma descrição';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 28),
              Text('CATEGORIA', style: sectionStyle),
              const SizedBox(height: 10),
              FormField<ExpenseCategory>(
                initialValue: _selectedCategory,
                validator: (value) {
                  if (value == null) {
                    return 'Selecione uma categoria';
                  }

                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ExpenseCategory.values.map((category) {
                          return ChoiceChip(
                            avatar: Icon(
                              category.icon,
                              size: 18,
                            ),
                            label: Text(category.label),
                            selected: field.value == category,
                            showCheckmark: false,
                            onSelected: (_) {
                              setState(() {
                                _selectedCategory = category;
                              });

                              field.didChange(category);
                            },
                          );
                        }).toList(),
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: Text(
                            field.errorText!,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 28),
              Text('DATA', style: sectionStyle),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Hoje'),
                    selected: isToday,
                    showCheckmark: false,
                    onSelected: (_) {
                      _selectDate(today);
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Ontem'),
                    selected: isYesterday,
                    showCheckmark: false,
                    onSelected: (_) {
                      _selectDate(yesterday);
                    },
                  ),
                  ChoiceChip(
                    avatar: const Icon(
                      Icons.calendar_month_rounded,
                      size: 18,
                    ),
                    label: Text(
                      isOtherDate
                          ? DateFormatter.fullDate(_selectedDate)
                          : 'Outra data',
                    ),
                    selected: isOtherDate,
                    showCheckmark: false,
                    onSelected: (_) {
                      _pickDate();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 40),
              FilledButton.icon(
                onPressed: _saveExpense,
                icon: Icon(
                  _isEditing ? Icons.check_rounded : Icons.add_rounded,
                ),
                label: Text(
                  _isEditing ? 'Salvar alterações' : 'Adicionar gasto',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## O que mudou

### Ordem dos campos

```text
VALOR        (grande, dourado, teclado abre sozinho)
DESCRIÇÃO
CATEGORIA    (botões com ícone)
DATA         (Hoje | Ontem | Outra data)
[ Adicionar gasto ]
```

O título do gasto agora se chama **Descrição** na tela. No código continua `title`, então os dados salvos não mudam.

### Teclado

```dart
autofocus: !_isEditing,
```

Em um gasto novo, o cursor já começa no valor e o teclado abre sozinho.

```dart
textInputAction: TextInputAction.next,
```

O botão do teclado vira "próximo" e leva para o campo seguinte.

### Só números no valor

```dart
inputFormatters: [
  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
],
```

`RegExp(r'[0-9.,]')` significa "aceitar apenas dígitos, ponto e vírgula". Qualquer outra tecla é ignorada.

### Categorias em botões

Uma lista de `ChoiceChip` não é um campo de formulário, então ela não teria validação. Por isso ela está dentro de:

```dart
FormField<ExpenseCategory>(...)
```

O `FormField` permite transformar **qualquer widget** em um campo com `validator`. Quando um botão é tocado, avisamos o campo:

```dart
field.didChange(category);
```

### Datas rápidas

`Hoje` e `Ontem` escolhem a data com um toque. `Outra data` abre o calendário. Quando a data escolhida não é hoje nem ontem, o terceiro botão mostra a data (exemplo: `25 de setembro de 2026`).

### Validação mais amigável

Antes da primeira tentativa de salvar, nenhum erro aparece. Depois dela:

```dart
AutovalidateMode.onUserInteraction
```

faz cada erro sumir assim que o campo é corrigido.

## Checkpoint

### Novo gasto

Toque em `+`.

- [ ] O teclado abre sozinho no campo de valor.
- [ ] O valor aparece grande e dourado.
- [ ] Não é possível digitar letras no valor.
- [ ] As sete categorias aparecem como botões com ícone.
- [ ] Ao tocar em uma categoria, ela fica verde.
- [ ] `Hoje` começa selecionado.
- [ ] Tocar em `Ontem` seleciona ontem.
- [ ] Tocar em `Outra data` abre o calendário.
- [ ] Depois de escolher uma data, o botão mostra a data escolhida.

### Validação

Toque em `Adicionar gasto` sem preencher nada.

- [ ] Aparece `Informe o valor`.
- [ ] Aparece `Informe uma descrição`.
- [ ] Aparece `Selecione uma categoria`.
- [ ] Ao digitar um valor, o erro do valor some na hora.
- [ ] Ao escolher uma categoria, o erro da categoria some na hora.

### Edição

Abra o menu de um gasto existente e escolha `Editar`.

- [ ] O valor aparece com vírgula (exemplo: `50,00`).
- [ ] A categoria do gasto já está selecionada.
- [ ] A data correta está selecionada.
- [ ] O teclado **não** abre sozinho.

---

# Etapa 11 — Nova tela de metas

Mudanças nesta tela:

- cada campo tem o ícone da categoria;
- **campo vazio significa "sem meta"** (antes era obrigatório digitar `0`);
- o valor só aceita números;
- o teclado navega de um campo para o outro;
- o total aparece em destaque.

Abra:

```text
lib/screens/budget_goals_page.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/expense_category.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../theme/category_icons.dart';
import '../utils/money_formatter.dart';

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
          text: _textFromValue(widget.currentGoals[category] ?? 0),
        ),
    };
  }

  // 0     → campo vazio
  // 300.5 → "300,50"
  static String _textFromValue(double value) {
    if (value == 0) {
      return '';
    }

    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  // Campo vazio → 0
  double _valueFromController(TextEditingController controller) {
    final text = controller.text.trim().replaceAll(',', '.');

    if (text.isEmpty) {
      return 0;
    }

    return double.tryParse(text) ?? 0;
  }

  double get _totalGoals {
    double total = 0;

    for (final controller in _controllers.values) {
      total += _valueFromController(controller);
    }

    return total;
  }

  void _saveGoals() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final goals = <ExpenseCategory, double>{};

    for (final category in ExpenseCategory.values) {
      goals[category] = _valueFromController(_controllers[category]!);
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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Metas mensais'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(
                'Quanto você pretende gastar por mês em cada categoria?',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'As metas valem para todos os meses. '
                'Deixe em branco as categorias sem meta.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              ...ExpenseCategory.values.map((category) {
                final isLast = category == ExpenseCategory.values.last;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextFormField(
                    controller: _controllers[category],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                    ],
                    textInputAction:
                        isLast ? TextInputAction.done : TextInputAction.next,
                    decoration: AppTheme.input(
                      label: category.label,
                      hintText: '0,00',
                      prefixText: '€ ',
                      prefixIcon: Icon(
                        category.icon,
                        color: AppColors.richGold,
                      ),
                    ),
                    onChanged: (_) {
                      setState(() {});
                    },
                    validator: (value) {
                      final text = (value ?? '').trim();

                      if (text.isEmpty) {
                        return null;
                      }

                      final goal = double.tryParse(
                        text.replaceAll(',', '.'),
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
              const SizedBox(height: 8),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Total mensal',
                          style: textTheme.titleMedium,
                        ),
                      ),
                      Text(
                        MoneyFormatter.format(_totalGoals),
                        style: textTheme.headlineSmall?.copyWith(
                          color: AppColors.richGold,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _saveGoals,
                icon: const Icon(Icons.check_rounded),
                label: const Text('Salvar metas'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## O que mudou

Antes, um campo vazio mostrava o erro `Informe uma meta`. Agora:

```text
campo vazio  →  sem meta  →  salvo como 0
```

Ao abrir a tela, metas `0` aparecem como campo vazio (com a dica `0,00`), e metas com valor aparecem com vírgula (`300,00`).

## Checkpoint

Toque no botão de metas.

- [ ] Cada campo tem o ícone dourado da categoria.
- [ ] Metas existentes aparecem com vírgula (exemplo: `300,00`).
- [ ] Metas zeradas aparecem vazias.
- [ ] Não é possível digitar letras.
- [ ] O botão do teclado leva para o próximo campo.
- [ ] O `Total mensal` aparece grande e dourado e muda enquanto se digita.
- [ ] Apagar o conteúdo de um campo e salvar não mostra erro.
- [ ] Ao salvar, os cards da Home são atualizados.

---

# Etapa 12 — Novo item de gasto: tocar para editar, deslizar para excluir

Em apps profissionais, as ações mais comuns são feitas por gestos:

```text
Tocar no gasto         →  editar
Deslizar para esquerda →  excluir
```

E, em vez de perguntar "Tem certeza?" antes de excluir, o app exclui na hora e oferece **Desfazer** por alguns segundos. Isso é mais rápido para quem tem certeza e igualmente seguro para quem se enganou.

Abra:

```text
lib/widgets/expense_tile.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../utils/money_formatter.dart';
import 'category_avatar.dart';

class ExpenseTile extends StatelessWidget {
  final Expense expense;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ExpenseTile({
    super.key,
    required this.expense,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Dismissible(
        key: ValueKey('dismissible-${expense.id}'),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          onDelete();
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: AppColors.danger,
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.delete_outline_rounded,
                color: AppColors.imperialPurple,
              ),
              SizedBox(width: 8),
              Text(
                'Excluir',
                style: TextStyle(
                  color: AppColors.imperialPurple,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 6,
            ),
            leading: CategoryAvatar(
              category: expense.category,
            ),
            title: Text(
              expense.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              expense.category.label,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            trailing: Text(
              MoneyFormatter.format(expense.amount),
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```

## O que mudou

O menu `⋮` com `Editar` e `Excluir` foi removido.

```dart
ListTile(onTap: onTap, ...)
```

Tocar em qualquer parte do gasto chama `onTap` (editar).

```dart
Dismissible(...)
```

É o widget do Flutter que permite deslizar um item para removê-lo:

- `direction: DismissDirection.endToStart` → só desliza da direita para a esquerda;
- `background:` → o que aparece por trás enquanto o item é arrastado (fundo rubi com `Excluir`);
- `onDismissed:` → chamado quando o item termina de sair da tela.

`Dismissible` exige uma `key` única, por isso usamos o `id` do gasto.

```dart
maxLines: 1,
overflow: TextOverflow.ellipsis,
```

Se a descrição for muito longa, ela termina com `...` em vez de quebrar o layout.

## Importante

O construtor mudou: `onEdit` virou `onTap`.

Depois desta alteração, o projeto mostrará erro em:

```text
lib/widgets/expense_day_group.dart
```

Isso é esperado. Vamos corrigir na próxima etapa.

Não execute o aplicativo ainda.

---

# Etapa 13 — Novo grupo de gastos do dia

Abra:

```text
lib/widgets/expense_day_group.dart
```

Apague tudo e copie o arquivo completo:

```dart
import 'package:flutter/material.dart';

import '../models/expense.dart';
import '../theme/app_colors.dart';
import '../utils/date_formatter.dart';
import '../utils/money_formatter.dart';
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final dayTotal = expenses.fold(
      0.0,
      (total, expense) => total + expense.amount,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  DateFormatter.dayTitle(day).toUpperCase(),
                  style: textTheme.labelLarge?.copyWith(
                    color: AppColors.richGold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              Text(
                MoneyFormatter.format(dayTotal),
                style: textTheme.labelLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        ...expenses.map(
          (expense) => ExpenseTile(
            key: ValueKey(expense.id),
            expense: expense,
            onTap: () {
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

## O que mudou

- O título do dia aparece em dourado e maiúsculas: `HOJE`, `ONTEM`, `25 DE SETEMBRO`;
- O total do dia usa o novo formatador;
- Cada `ExpenseTile` recebe uma `key` com o `id` do gasto.

### Por que a `key` é importante aqui

Quando um item é removido de uma lista, o Flutter precisa saber **qual** item saiu. Sem a `key`, ele compara pela posição, e pode "confundir" os itens durante a animação. Com a `key`, ele identifica cada gasto pelo `id`.

## Importante

Agora o projeto **compila**, mas **não execute ainda**.

A Home atual (Fase 3) mostra uma janela de confirmação **depois** que o item já foi deslizado para fora da tela. O Flutter não aceita isso e mostraria um erro vermelho ao deslizar. A próxima etapa corrige isso.

---

# Etapa 14 — Nova Home

Mudanças na Home:

- novo layout com títulos de seção;
- botão `Novo gasto` com texto (mais claro que só `+`);
- só aparecem as categorias que têm meta ou gasto no mês;
- estado vazio com botão quando não há metas;
- estado vazio quando o mês não tem gastos;
- exclusão imediata com **Desfazer**;
- mensagens de confirmação depois de salvar;
- botão `Voltar para o mês atual`.

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
import '../widgets/empty_state.dart';
import '../widgets/expense_day_group.dart';
import '../widgets/month_selector.dart';
import '../widgets/section_title.dart';
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

  DateTime _selectedMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  bool get _isCurrentMonth {
    return DateFormatter.isSameMonth(_selectedMonth, DateTime.now());
  }

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

      return b.id.compareTo(a.id);
    });

    return expenses;
  }

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

  void _goToCurrentMonth() {
    final now = DateTime.now();

    setState(() {
      _selectedMonth = DateTime(now.year, now.month);
    });
  }

  // Mostra uma mensagem curta na parte de baixo da tela.
  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
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

      _selectedMonth = DateTime(
        expense.date.year,
        expense.date.month,
      );
    });

    _showMessage('Gasto adicionado.');

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

      _selectedMonth = DateTime(
        updatedExpense.date.year,
        updatedExpense.date.month,
      );
    });

    _showMessage('Alterações salvas.');

    await _storage.saveExpenses(_expenses);
  }

  // Chamado quando o gasto é deslizado para fora da tela.
  // Remove na hora (o Dismissible exige isso) e oferece "Desfazer".
  Future<void> _deleteExpense(Expense expense) async {
    final index = _expenses.indexWhere(
      (item) => item.id == expense.id,
    );

    if (index == -1) {
      return;
    }

    setState(() {
      _expenses.removeAt(index);
    });

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('"${expense.title}" foi excluído.'),
          showCloseIcon: true,
          action: SnackBarAction(
            label: 'Desfazer',
            onPressed: () {
              _undoDelete(expense, index);
            },
          ),
        ),
      );

    await _storage.saveExpenses(_expenses);
  }

  Future<void> _undoDelete(Expense expense, int index) async {
    if (!mounted) {
      return;
    }

    setState(() {
      final safeIndex = index.clamp(0, _expenses.length).toInt();

      _expenses.insert(safeIndex, expense);

      _selectedMonth = DateTime(
        expense.date.year,
        expense.date.month,
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

    _showMessage('Metas atualizadas.');

    await _storage.saveGoals(_goals);
  }

  @override
  Widget build(BuildContext context) {
    final expensesByDay = _expensesByDay;

    // Só mostra categorias com meta ou com gasto no mês.
    final visibleCategories = ExpenseCategory.values
        .where(
          (category) =>
              (_goals[category] ?? 0) > 0 || spentByCategory(category) > 0,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orçamento Mensal'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _openBudgetGoals,
            icon: const Icon(Icons.tune_rounded),
            tooltip: 'Metas mensais',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                children: [
                  MonthSelector(
                    selectedMonth: _selectedMonth,
                    onPrevious: _goToPreviousMonth,
                    onNext: _isCurrentMonth ? null : _goToNextMonth,
                    onCurrentMonth: _isCurrentMonth ? null : _goToCurrentMonth,
                  ),
                  const SizedBox(height: 16),
                  BudgetSummaryCard(
                    budget: _totalBudget,
                    spent: _totalSpent,
                  ),
                  const SectionTitle(
                    title: 'Metas por categoria',
                    subtitle: 'Consumo de cada meta no mês selecionado',
                  ),
                  if (_totalBudget == 0)
                    EmptyState(
                      icon: Icons.flag_rounded,
                      title: 'Defina suas metas',
                      message:
                          'Escolha quanto pretende gastar por mês em cada categoria.',
                      actionLabel: 'Definir metas',
                      onAction: _openBudgetGoals,
                    ),
                  ...visibleCategories.map(
                    (category) => CategoryBudgetCard(
                      category: category,
                      goal: _goals[category] ?? 0,
                      spent: spentByCategory(category),
                    ),
                  ),
                  SectionTitle(
                    title: 'Histórico',
                    subtitle: expensesByDay.isEmpty
                        ? null
                        : 'Toque para editar • deslize para a esquerda para excluir',
                  ),
                  if (expensesByDay.isEmpty)
                    const EmptyState(
                      icon: Icons.receipt_long_rounded,
                      title: 'Nenhum gasto neste mês',
                      message:
                          'Toque em "Novo gasto" para registrar o primeiro.',
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
                ],
              ),
      ),
      floatingActionButton: _isLoading
          ? null
          : FloatingActionButton.extended(
              onPressed: _openAddExpense,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Novo gasto'),
            ),
    );
  }
}
```

## O que mudou

### Exclusão com Desfazer

Antes:

```text
Excluir → janela "Tem certeza?" → Excluir → gasto removido
```

Agora:

```text
Deslizar → gasto removido → mensagem com "Desfazer"
```

Ao excluir, guardamos a posição do gasto na lista:

```dart
final index = _expenses.indexWhere(...);
```

Se o usuário tocar em `Desfazer`, o gasto volta para a mesma posição:

```dart
_expenses.insert(safeIndex, expense);
```

`clamp(0, _expenses.length)` garante que a posição nunca seja maior que o tamanho atual da lista.

`showCloseIcon: true` coloca um `X` na mensagem para fechá-la manualmente.

### Mensagens de confirmação

```dart
_showMessage('Gasto adicionado.');
```

`ScaffoldMessenger` é quem mostra as mensagens (`SnackBar`). O `hideCurrentSnackBar()` fecha a mensagem anterior antes de mostrar a nova, para elas não se acumularem.

### Lista mais limpa

```dart
final visibleCategories = ...
```

Categorias sem meta **e** sem gasto no mês não aparecem. Se a Casa não tem meta nem gasto, não há nada útil para mostrar sobre ela.

### Botão com texto

```dart
FloatingActionButton.extended(
  icon: const Icon(Icons.add_rounded),
  label: const Text('Novo gasto'),
)
```

Um botão só com `+` obriga o usuário a adivinhar. Com texto, a ação fica clara.

### `ListView` em vez de `SingleChildScrollView` + `Column`

Para listas, `ListView` é o widget mais indicado. O `padding` de baixo (`120`) garante que o último gasto não fique escondido atrás do botão `Novo gasto`.

## Checkpoint

Agora pode executar:

```bash
flutter run
```

- [ ] A Home abre sem erros.
- [ ] O seletor de mês, o resumo, as metas e o histórico aparecem no novo visual.
- [ ] Os títulos `Metas por categoria` e `Histórico` têm uma barra dourada à esquerda.
- [ ] O botão de baixo mostra `Novo gasto`.
- [ ] Tocar em um gasto abre a edição.
- [ ] Deslizar um gasto para a esquerda mostra o fundo rubi com `Excluir`.
- [ ] Não existem erros vermelhos.

---

# Etapa 15 — Testar as situações de orçamento

> Os valores abaixo continuam do final da Fase 3: em setembro existem **Mercado (€ 50)**, **Café (€ 3)** e **Uber (€ 12)**, e as metas somam **€ 1.300,00**. Se seus dados forem diferentes, os números mudam, mas o comportamento é o mesmo.

## 1. Situação normal

Em setembro, o resumo deve mostrar:

```text
DISPONÍVEL PARA GASTAR
€ 1.235,00

Gasto: € 65,00           Orçamento: € 1.300,00

✓ Tudo sob controle: você usou 5% do orçamento.
```

- [ ] O valor está em dourado.
- [ ] O ícone da mensagem está em esmeralda.
- [ ] Aparece o separador de milhar.

## 2. Categoria em atenção

Abra as metas e altere:

```text
Alimentação: 60
```

Salve.

- [ ] Aparece a mensagem `Metas atualizadas.`
- [ ] Alimentação mostra `88%` em dourado.
- [ ] Alimentação mostra `Restam € 7,00`.

## 3. Categoria estourada

Cadastre:

```text
Valor: 100
Descrição: Táxi
Categoria: Transporte
Data: Hoje
```

- [ ] Aparece a mensagem `Gasto adicionado.`
- [ ] Transporte mostra `112%` em rubi.
- [ ] Transporte mostra `Excedeu € 12,00`.

## 4. Orçamento do mês em atenção

As metas agora somam `€ 1.060,00`. Cadastre:

```text
Valor: 800
Descrição: Viagem
Categoria: Lazer
Data: Hoje
```

O resumo deve mostrar:

```text
DISPONÍVEL PARA GASTAR
€ 95,00

! Atenção: você já usou 91% do orçamento.
```

- [ ] O ícone da mensagem está em dourado.

## 5. Orçamento do mês estourado

Toque na `Viagem` e altere o valor para `900`. Salve.

- [ ] Aparece a mensagem `Alterações salvas.`

O resumo deve mostrar:

```text
ACIMA DO ORÇAMENTO
€ 5,00

⚠ Você ultrapassou o orçamento deste mês.
```

- [ ] O valor grande está em rubi.
- [ ] A barra do resumo está cheia e em rubi.

---

# Etapa 16 — Testar a exclusão com Desfazer

Deslize a `Viagem` para a esquerda.

- [ ] O gasto sai da tela.
- [ ] Aparece `"Viagem" foi excluído.` com o botão `Desfazer`.
- [ ] O resumo volta para `Disponível para gastar`.

Toque em `Desfazer`.

- [ ] A Viagem volta para a lista, no mesmo lugar.
- [ ] O resumo volta para `Acima do orçamento`.

Deslize a `Viagem` de novo e **não** toque em `Desfazer`. Depois, deslize também o `Táxi`.

- [ ] A mensagem da Viagem é substituída pela do Táxi.

Feche o aplicativo completamente e abra de novo:

```bash
flutter run
```

- [ ] Viagem e Táxi não voltaram.
- [ ] A meta de Alimentação continua `€ 60,00`.

Se quiser, volte a meta de Alimentação para `300`.

---

# Etapa 17 — Testar estados vazios e navegação

## Mês sem gastos

Toque na seta da esquerda até chegar em `Julho de 2026`.

- [ ] O histórico mostra o card `Nenhum gasto neste mês`.
- [ ] Aparece o botão `Voltar para o mês atual`.
- [ ] Tocar nele volta para o mês atual.
- [ ] No mês atual, o botão `Voltar para o mês atual` não aparece.

## Sem metas

Abra as metas, **apague o conteúdo de todos os campos** e salve.

- [ ] Não aparece nenhum erro.
- [ ] O resumo mostra `GASTO NO MÊS` e o valor em creme.
- [ ] Aparece o card `Defina suas metas` com o botão `Definir metas`.
- [ ] Só aparecem as categorias que têm gasto no mês, com `Sem meta definida`.
- [ ] O botão `Definir metas` abre a tela de metas.

Preencha as metas novamente:

```text
Alimentação: 300
Transporte:  100
Lazer:       150
Compras:     200
Casa:        400
Educação:    100
Outros:      50
```

## Texto grande (acessibilidade)

Muitas pessoas usam o celular com letras maiores. Um app profissional precisa continuar funcionando assim.

No emulador ou celular, abra **Configurações → Tela (ou Acessibilidade) → Tamanho da fonte** e escolha o maior tamanho. Volte para o app.

- [ ] Nenhum texto aparece cortado com faixas amarelas e pretas.
- [ ] O valor do resumo continua cabendo na tela.
- [ ] As categorias do formulário quebram para a linha de baixo.

Depois, volte o tamanho da fonte ao normal.

---

# Resultado visual esperado

```text
ORÇAMENTO MENSAL                              ⚙

   (<)        MÊS SELECIONADO          (>)
              Setembro de 2026

╔══════════════════════════════════════════╗   ← degradê verde → roxo
║ DISPONÍVEL PARA GASTAR                   ║     borda dourada
║ € 1.235,00                               ║   ← Playfair, dourado
║ ██░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ║
║ Gasto              Orçamento             ║
║ € 65,00            € 1.300,00            ║
║ ✓ Tudo sob controle: você usou 5% ...    ║
╚══════════════════════════════════════════╝

▌ Metas por categoria
  Consumo de cada meta no mês selecionado

┌──────────────────────────────────────────┐
│ (🍴) Alimentação                     18% │
│      € 53,00 de € 300,00                 │
│ ███████░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  │
│ Restam € 247,00                          │
└──────────────────────────────────────────┘

▌ Histórico
  Toque para editar • deslize para a esquerda para excluir

HOJE                                € 53,00
┌──────────────────────────────────────────┐
│ (🍴) Café                        € 3,00  │
│      Alimentação                         │
└──────────────────────────────────────────┘
┌──────────────────────────────────────────┐
│ (🍴) Mercado                    € 50,00  │
│      Alimentação                         │
└──────────────────────────────────────────┘

                              [ + Novo gasto ]
```

---

# Checklist da Fase 4

## Identidade visual

- [ ] Fundo roxo escuro em todas as telas.
- [ ] Cards roxos com borda fina.
- [ ] Botões principais dourados.
- [ ] Resumo com degradê verde garrafa → roxo imperial.
- [ ] Títulos e valores em Playfair Display.
- [ ] Textos em Inter.
- [ ] Calendário com as cores do app.

## Componentes

- [ ] Ícone para cada categoria.
- [ ] Títulos de seção com barra dourada.
- [ ] Estados vazios com ícone, explicação e botão quando faz sentido.
- [ ] Valores com separador de milhar.

## Resumo e categorias

- [ ] Valor disponível em destaque.
- [ ] Cores esmeralda, dourado e rubi conforme a situação.
- [ ] Sempre existe texto junto da cor.
- [ ] Categorias sem meta e sem gasto ficam escondidas.

## Formulário de gasto

- [ ] Valor em destaque e teclado abrindo sozinho.
- [ ] Valor não aceita letras.
- [ ] Categorias em botões com ícone.
- [ ] Atalhos `Hoje` e `Ontem`.
- [ ] Erros somem enquanto o usuário corrige.

## Metas

- [ ] Campo vazio = sem meta.
- [ ] Ícone em cada campo.
- [ ] Total mensal em destaque.

## Interações

- [ ] Tocar no gasto abre a edição.
- [ ] Deslizar exclui.
- [ ] `Desfazer` restaura o gasto.
- [ ] Mensagens depois de adicionar, editar e salvar metas.
- [ ] Botão `Voltar para o mês atual`.
- [ ] Botão `Novo gasto` com texto.

---

# Arquivos alterados nesta fase

Modificados:

```text
lib/main.dart
lib/screens/add_expense_page.dart
lib/screens/budget_goals_page.dart
lib/screens/home_page.dart
lib/widgets/budget_summary_card.dart
lib/widgets/category_budget_card.dart
lib/widgets/expense_day_group.dart
lib/widgets/expense_tile.dart
lib/widgets/month_selector.dart
```

Novos:

```text
lib/theme/app_colors.dart
lib/theme/app_theme.dart
lib/theme/category_icons.dart
lib/utils/money_formatter.dart
lib/widgets/category_avatar.dart
lib/widgets/empty_state.dart
lib/widgets/section_title.dart
```

Não foram alterados:

```text
lib/models/expense.dart
lib/models/expense_category.dart
lib/services/local_storage_service.dart
lib/utils/date_formatter.dart
```

Nova dependência:

```text
google_fonts
```

---

# O que foi aprendido nesta fase

Além do conteúdo das fases anteriores, agora trabalhamos com:

- `ThemeData` e tema escuro;
- `ColorScheme` personalizado;
- `TextTheme` e os nomes de estilo (`displaySmall`, `titleLarge`...);
- fontes externas com `google_fonts`;
- `CardThemeData`, `FilledButtonThemeData`, `SnackBarThemeData`;
- centralização de cores em uma classe;
- `extension`;
- `switch` como expressão;
- `LinearGradient`, `BoxShadow`, `BorderRadius`;
- `withValues(alpha: ...)` para transparência;
- `FittedBox`;
- `ClipRRect`;
- widgets privados (`_SummaryValue`);
- `ChoiceChip` e `Wrap`;
- `FormField` personalizado;
- `inputFormatters` e `RegExp`;
- `autofocus`, `textInputAction` e `textCapitalization`;
- `AutovalidateMode`;
- `Dismissible`;
- `Key` e `ValueKey`;
- `SnackBar`, `SnackBarAction` e `ScaffoldMessenger`;
- `FloatingActionButton.extended`;
- `IconButton.filledTonal`;
- `ListView`;
- princípios de UX: hierarquia, feedback, prevenção de erros, desfazer, estados vazios, acessibilidade.

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
❌ Animações personalizadas
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

# Próxima evolução possível — Fase 5

Depois que esta fase estiver funcionando, algumas evoluções naturais seriam:

1. ícone do aplicativo e tela de abertura com a identidade visual;
2. gráfico de pizza com os gastos por categoria;
3. comparação entre o mês atual e o anterior;
4. metas diferentes para cada mês;
5. busca e filtro por categoria no histórico.
