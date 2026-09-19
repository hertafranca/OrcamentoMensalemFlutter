enum ExpenseCategory {
  restaurant('Restaurant'),
  transport('Transport'),
  clothes('Clothes'),
  education('Education'),
  leisure('Leisure');

  final String label;

  const ExpenseCategory(this.label);
}
