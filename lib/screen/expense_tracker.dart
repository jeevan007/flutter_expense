import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expense/bloc/expense_bloc.dart';
import 'package:flutter_expense/bloc/expense_event.dart';
import 'package:flutter_expense/bloc/expense_state.dart';
import 'package:intl/intl.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ExpenseBloc()..add(FetchExpenses()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Monety',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          ],
        ),
        body: const ExpenseTrackerBody(),
      ),
    );
  }
}

class ExpenseTrackerBody extends StatefulWidget {
  const ExpenseTrackerBody({super.key});

  @override
  State<ExpenseTrackerBody> createState() => _ExpenseTrackerBodyState();
}

class _ExpenseTrackerBodyState extends State<ExpenseTrackerBody> {
  final List<String> list = <String>[
    'This month',
    'Last month',
    'This year',
    'Last year',
  ];
  late String selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = list.first;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Profile Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/profile.jpg'),
                    ),
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Morning',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      ),
                      Text(
                        'Leena Smith',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownMenu<String>(
                  initialSelection: selectedValue,
                  onSelected: (String? value) {
                    setState(() {
                      selectedValue = value!;
                    });
                  },
                  dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((
                    String value,
                  ) {
                    return DropdownMenuEntry<String>(
                      value: value,
                      label: value,
                    );
                  }).toList(),
                ),
              ),
            ],
          ),

          // Total Balance Banner Card
          Container(
            height: 180,
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 52, 94, 163),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Total Balance',
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '\$ 3,734',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: const Image(
                      image: AssetImage('assets/images/expense.jpg'),
                      height: 100,
                      width: 120,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Expense List',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),

          // Dynamic Live List Section
          Expanded(
            child: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ExpenseLoaded) {
                  // Group elements dynamically by date from bloc state array
                  final Map<String, List<dynamic>> dynamicDailyExpenses = {};

                  for (var expense in state.expenses) {
                    final String dateKey = expense.expense_date.toString();

                    if (dynamicDailyExpenses[dateKey] == null) {
                      dynamicDailyExpenses[dateKey] = [];
                    }
                    dynamicDailyExpenses[dateKey]!.add(expense);
                  }

                  // Flatten mapped entries into structured presentation items
                  final List<Map<String, dynamic>> processedListItems = [];

                  dynamicDailyExpenses.forEach((date, expensesList) {
                    final num dayTotal = expensesList
                        .map((e) => e.expense_amount as num)
                        .fold<num>(0, (sum, currentItem) => sum + currentItem);

                    processedListItems.add({
                      'type': 'header',
                      'date': date,
                      'total': dayTotal,
                    });

                    for (var expense in expensesList) {
                      processedListItems.add({
                        'type': 'item',
                        'category': expense.expense_category,
                        'amount': expense.expense_amount,
                      });
                    }
                  });

                  if (processedListItems.isEmpty) {
                    return const Center(child: Text("No expenses found."));
                  }

                  return ListView.builder(
                    itemCount: dynamicDailyExpenses.keys.length,
                    itemBuilder: (context, index) {
                      final date = dynamicDailyExpenses.keys.elementAt(index);
                      final expensesList = dynamicDailyExpenses[date]!;

                      // ✅ Only Expense Total
                      num totalExpense = 0;
                      for (var e in expensesList) {
                        
                        if (e.expense_type != 1) {
                          totalExpense -= e.expense_amount;
                        }else{
                          totalExpense += e.expense_amount;
                        }
                      }

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 🔹 HEADER (DATE + TOTAL EXPENSE)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    DateFormat("dd-MM-yyyy").format(DateFormat("dd-MM-yyyy").parse(date)),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "\$${totalExpense.toStringAsFixed(2)}",
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // 🔹 EXPENSE ROWS
                              Column(
                                children: expensesList.map((expense) {
                                  // 👉 Map category to image
                                  String getCategoryImage(String category) {
                                    switch (category.toLowerCase()) {
                                      case 'food':
                                        return 'assets/images/food.jpg';
                                      case 'transport':
                                        return 'assets/images/travel.jpg';
                                      case 'shopping':
                                        return 'assets/images/shopping.jpg';
                                      case 'bills':
                                        return 'assets/images/bills.jpg';
                                      default:
                                        return 'assets/images/cash.jpg';
                                    }
                                  }

                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        // 🔹 CATEGORY IMAGE
                                        CircleAvatar(
                                          radius: 20,
                                          backgroundColor: Colors.grey.shade100,
                                          backgroundImage: AssetImage(
                                            getCategoryImage(
                                              expense.expense_category,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 12),

                                        // 🔹 CATEGORY + DESCRIPTION
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                expense.expense_category,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                expense.expense_desc ??
                                                    "No description",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // 🔹 AMOUNT
                                        Text(
                                          "${expense.expense_type != 1 ? "- " : "+ "}\$${expense.expense_amount.toStringAsFixed(2)}",
                                          style: const TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("Failed to load live data"));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
