enum ExpenseCategory {
  food('🛎️🍽️☕🥂FOOD'),
  transport('🛫🚕🚌🚂TRANSPORT'),
  leisure('🏖️🍿🎭💃🏻🕺🏽LEISURE'),
  shopping('🛍️🛒🎁🧾SHOPPING'),
  home('🏠🛜💡💧HOME'),
  education('👩‍💻📚🎓🎯EDUCATION'),
  other('💫🦋🌷💫OTHER');
//criar categorias .
  final String label;

  const ExpenseCategory(this.label);

  // Converte o nome salvo no celular de volta para uma categoria.
  // Também converte as categorias antigas da Fase 2.
  static ExpenseCategory fromName(String name) {
    if (name == 'restaurant') {
      return ExpenseCategory.food;
    }/// Converte uma string com o nome da categoria para o enum.

    if (name == 'clothes') {
      return ExpenseCategory.shopping;
    }

    return ExpenseCategory.values.firstWhere(
      (category) => category.name == name,// Se o nome for 'restaurant', mapeia para a categoria de alimentação (food)
      orElse: () => ExpenseCategory.other,
    );
  }
}
 // TODO: Adicionar um retorno padrão ou lançar uma exceção caso o nome não seja mapeado