enum ExpenseCategory {
  food('🛎️🍽️☕🥂FOOD'),
  transport('🛫🚕🚌🚂TRANSPORT'),
  leisure('🏖️🍿🎭💃🏻🕺🏽LEISURE'),
  shopping('🛍️🛒🎁🧾SHOPPING'),
  home('🏠🛜💡💧HOME'),
  education('👩‍💻📚🎓🎯EDUCATION'),
  other('💫🦋🌷💫OTHER');

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
