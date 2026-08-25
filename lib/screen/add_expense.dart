import 'package:flutter/material.dart';
import 'package:flutter_expense/model/expense.dart';
import 'package:intl/intl.dart';
import 'package:flutter_expense/db/db_helpher.dart';

class AddExpense extends StatelessWidget {
  const AddExpense({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController expenseCategoryController = TextEditingController();
    TextEditingController expenseDescriptionController =
        TextEditingController();
    TextEditingController expenseAmountController = TextEditingController();
    TextEditingController expenseTypeController = TextEditingController();
    TextEditingController expenseDateController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    void clearControllers() {
      expenseCategoryController.clear();
      expenseDescriptionController.clear();
      expenseAmountController.clear();
      expenseTypeController.clear();
      expenseDateController.clear();
    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Add Transaction',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenuFormField(
                      decorationBuilder:
                          (BuildContext context, MenuController controller) {
                            // Check if the dropdown panel is currently open
                            final bool isOpen = controller.isOpen;

                            return InputDecoration(
                              labelText: 'Select Expense Category',
                              labelStyle: TextStyle(
                                color: isOpen ? Colors.pink : Colors.grey,
                                fontWeight: isOpen
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              // Dynamically change the input border look based on open/closed state
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: isOpen ? Colors.pink : Colors.grey,
                                  width: isOpen ? 2.0 : 1.0,
                                ),
                              ),
                              // Add a custom visual cue prefix icon
                              prefixIcon: Icon(
                                Icons.shopping_bag,
                                color: isOpen ? Colors.pink : Colors.grey,
                              ),
                            );
                          },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: 'Food', label: 'Food'),
                        DropdownMenuEntry(
                          value: 'Transport',
                          label: 'Transport',
                        ),
                        DropdownMenuEntry(
                          value: 'Entertainment',
                          label: 'Entertainment',
                        ),
                        DropdownMenuEntry(value: 'Shopping', label: 'Shopping'),
                        DropdownMenuEntry(value: 'Bills', label: 'Bills'),
                        DropdownMenuEntry(value: 'Cash', label: 'Cash'),
                        DropdownMenuEntry(value: 'Other', label: 'Other'),
                      ],
                      onSelected: (String? newValue) {
                        // Conditional Logic: Auto-set Type controller if CASH is chosen
                        if (newValue == 'Cash') {
                          expenseTypeController.text = 'Income';
                        }else{
                          expenseTypeController.text = 'Expense';
                        }
                      },
                      initialSelection: 'Food',
                      width: 450,
                      controller: expenseCategoryController,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: expenseDescriptionController,
                      decoration: InputDecoration(
                        labelText: 'Expense Description',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Expense description cannot be empty';
                        }
                        if (value.length < 3) {
                          return 'Expense description must be at least 3 characters long';
                        }

                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: expenseAmountController,
                      decoration: InputDecoration(
                        labelText: 'Expense Amount',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Expense amount cannot be empty';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownMenuFormField(
                      decorationBuilder:
                          (BuildContext context, MenuController controller) {
                            // Check if the dropdown panel is currently open
                            final bool isOpen = controller.isOpen;

                            return InputDecoration(
                              labelText: 'Select Expense Category',
                              labelStyle: TextStyle(
                                color: isOpen ? Colors.pink : Colors.grey,
                                fontWeight: isOpen
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                              // Dynamically change the input border look based on open/closed state
                              border: const OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: isOpen ? Colors.pink : Colors.grey,
                                  width: isOpen ? 2.0 : 1.0,
                                ),
                              ),
                              // Add a custom visual cue prefix icon
                              prefixIcon: Icon(
                                Icons.attach_money,
                                color: isOpen ? Colors.pink : Colors.grey,
                              ),
                            );
                          },
                      dropdownMenuEntries: [
                        DropdownMenuEntry(value: 'Income', label: 'Income'),
                        DropdownMenuEntry(value: 'Expense', label: 'Expense'),
                      ],
                      initialSelection: 'Expense',
                      width: 450,
                      controller: expenseTypeController,

                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: expenseDateController,
                      decoration: InputDecoration(
                        labelText: 'Expense Date',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          // Format the date and set it to the controller
                          expenseDateController.text = DateFormat(
                            'dd-MM-yyyy',
                          ).format(pickedDate);
                        }
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        
                        DbHelpher dbHelper = DbHelpher.instance;
                        dbHelper
                            .insertExpense(
                              table: DbHelpher.TABLE_Expense,
                              expense: Expense(
                                expense_desc: expenseDescriptionController.text,
                                expense_amount: double.parse(
                                  expenseAmountController.text,
                                ),
                                expense_category:
                                    expenseCategoryController.text,
                                expense_date: DateFormat(
                                  'dd-MM-yyyy',
                                ).parse(expenseDateController.text),
                                expense_type:
                                    expenseTypeController.text == 'Income'
                                    ? 1
                                    : 0,
                              ),
                            )
                            .then((success) {
                              if (success) {
                                clearControllers();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Transaction added successfully!',
                                    ),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to add transaction.'),
                                  ),
                                );
                              }
                            });
                      }
                    },
                    child: Text('Add'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
