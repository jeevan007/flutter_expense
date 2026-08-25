class Expense {
  final int? expense_id;
  final String expense_category;
  final String expense_desc;
  final double expense_amount;
  final int expense_type;
  final DateTime expense_date;


  Expense({
    this.expense_id,
    required this.expense_desc,
    required this.expense_amount,
    required this.expense_category,
    required this.expense_date,
    required this.expense_type,
  });

  Map<String, dynamic> toMap() {
    return {
      'expense_id': expense_id,
      'expense_desc': expense_desc,
      'expense_amount': expense_amount,
      'expense_category': expense_category,
      'expense_date': expense_date.toIso8601String(),
      'expense_type': expense_type,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      expense_id: map['expense_id'],
      expense_desc: map['expense_desc'],
      expense_amount: map['expense_amount'],
      expense_category: map['expense_category'],
      expense_date: DateTime.parse(map['expense_date']),
      expense_type: map['expense_type'],
    );
  }
}
