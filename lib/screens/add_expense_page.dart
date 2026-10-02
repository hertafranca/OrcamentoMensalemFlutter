import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';
import '../utils/date_formatter.dart';
//importa os modelos de dados necessários para a página de adicionar despesas.
class AddExpensePage extends StatefulWidget {
  final Expense? expenseToEdit;
//adiciona a página de gastos e edita.
  const AddExpensePage({super.key, this.expenseToEdit});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}
//criar o estado da página de adicionar despesas, 
//que gerencia a lógica e o estado da interface do usuário.
class _AddExpensePageState extends State<AddExpensePage> {
  final _formKey = GlobalKey<FormState>();
//cria uma chave global para o formulário,
// permitindo a validação e o gerenciamento do estado do formulário.
  late final TextEditingController _titleController;
  late final TextEditingController _amountController;
//cria controladores de texto para os campos de título e valor,
// permitindo a leitura e a manipulação do texto inserido pelo usuário.
  ExpenseCategory? _selectedCategory;
  late DateTime _selectedDate;
//variáveis para armazenar a categoria selecionada e a data selecionada,
// permitindo que o usuário escolha uma categoria e uma data para a despesa.
  bool get _isEditing {
    return widget.expenseToEdit != null;
  }
//verifica se a página está em modo de edição,
// retornando true se houver uma despesa a ser editada e false caso contrário.
  @override
  void initState() {
    super.initState();
//inicializa o estado da página, configurando os controladores de texto e
// as variáveis de categoria e data com base na despesa a ser editada, se houver.
    final expense = widget.expenseToEdit;

    _titleController = TextEditingController(text: expense?.title ?? '');

    _amountController = TextEditingController(
      text: expense == null ? '' : expense.amount.toStringAsFixed(2),
    );
//inicializa os controladores de texto com o título e o valor da despesa
// a ser editada,
// ou com valores padrão caso não haja despesa a ser editada.
    _selectedCategory = expense?.category;

    // Novo gasto: começa com a data de hoje.
    // Edição: começa com a data do gasto.
    _selectedDate = expense?.date ?? DateFormatter.onlyDate(DateTime.now());
  }

  Future<void> _pickDate() async {
    final today = DateFormatter.onlyDate(DateTime.now());
//exibe um seletor de data para o usuário escolher a data da despesa,
// limitando a seleção entre o ano 2000 e a data atual.
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate.isAfter(today) ? today : _selectedDate,
      firstDate: DateTime(2000),
      lastDate: today,
      helpText: ' Expense Date ',
    );
// verifica se o usuário selecionou uma data válida e 
//se a página ainda está montada,
// atualizando a variável _selectedDate com a data escolhida.
    if (pickedDate == null || !mounted) {
      return;
    }

    setState(() {
      _selectedDate = DateFormatter.onlyDate(pickedDate);
    });
  }
//salva a despesa, validando o formulário e criando um novo objeto Expense
// ou atualizando um existente,
// e retorna à página anterior com a despesa salva.
  void _saveExpense() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }
//valida o formulário e retorna se não for válido, 
//impedindo o salvamento de dados inválidos. 
    final amount = double.parse(_amountController.text.replaceAll(',', '.'));

    final existingExpense = widget.expenseToEdit;

    final expense = existingExpense == null
        ? Expense(
            id: DateTime.now().microsecondsSinceEpoch.toString(),
            title: _titleController.text.trim(),
            category: _selectedCategory!,
            amount: amount,
            date: _selectedDate,
          )// cria um novo objeto Expense com os dados inseridos pelo usuário
          // caso não haja uma despesa existente a ser editada.
        : existingExpense.copyWith(
            title: _titleController.text.trim(),
            category: _selectedCategory!,
            amount: amount,
            date: _selectedDate,
          );
// atualiza a despesa existente com os novos dados inseridos pelo usuário.
    Navigator.pop(context, expense);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();

    super.dispose();
  }
//descarta os controladores de texto quando a página
// é removida da árvore de widgets,
// liberando recursos e evitando vazamentos de memória.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? 'Edit expense' : 'New expense')),
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
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Inform a title';
                    }

                    return null;
                  },
                ),
                //cria um campo de texto para o título da despesa,
                // com validação para garantir que o usuário insira
                // um título válido.
                const SizedBox(height: 16),
                DropdownButtonFormField<ExpenseCategory>(
                  initialValue: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),//cria um campo de seleção suspensa para a categoria da despesa,
                  // permitindo que o usuário escolha entre as categorias disponíveis.
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
                      return 'Select a category';
                    }
//valida a seleção da categoria, garantindo que o usuário escolha uma
//  categoria válida.
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),//cria um campo de texto para o valor da despesa,
                  // permitindo que o usuário insira um valor numérico
                  // com casas decimais.
                  decoration: const InputDecoration(
                    labelText: 'Value',
                    prefixText: '€ ',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Inform the value';
                    }
//valida o valor inserido, garantindo que o usuário forneça
// um valor válido e maior que zero.
                    final amount = double.tryParse(value.replaceAll(',', '.'));

                    if (amount == null) {
                      return 'Inform a valid value';
                    }

                    if (amount <= 0) {
                      return 'The value must be greater than zero';
                    }

                    return null;
                  },
                ),//cria um campo de texto para o valor da despesa, 
                // permitindo que o usuário insira um valor numérico 
                //com casas decimais,
                const SizedBox(height: 16),
                InkWell(
                  onTap: _pickDate,
                  borderRadius: BorderRadius.circular(4),
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),//cria um campo de entrada para a data da despesa,
                    // permitindo que o usuário selecione uma data usando 
                    //um seletor de data.
                    child: Text(DateFormatter.fullDate(_selectedDate)),
                  ),
                  //exibe a data selecionada no campo de entrada,
                  // formatada de acordo com o padrão
                  // definido na classe DateFormatter.
                  //quando o usuário toca no campo, o método _pickDate é 
                  //chamado para abrir o seletor de data.
                ),//cria um campo de entrada para a data da despesa, 
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _saveExpense,
                  child: Text(_isEditing ? 'Salve change' : 'Add expense'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
//cria a interface do usuário da página de adicionar despesas,
// incluindo campos de entrada para título, categoria, valor e data,  