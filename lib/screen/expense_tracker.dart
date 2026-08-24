import 'package:flutter/material.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({super.key});

  @override
  State<ExpenseTracker> createState() => _ExpennseTrackerState();
}

class _ExpennseTrackerState extends State<ExpenseTracker> {
  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> dailyExpenses = {
      'August 24, 2026': [
        {'category': 'shopping', 'amount': 45},
        {'category': 'electronic', 'amount': 120},
      ],
      'August 23, 2026': [
        {'category': 'transport', 'amount': 12},
      ],
    };

    final List<dynamic> listItems = [];

    dailyExpenses.forEach((date, expenses) {
      // Calculate total for the specific day
      final dayTotal = expenses
          .map((e) => e['amount'] as int)
          .reduce((a, b) => a + b);

      // Add Header Item
      listItems.add({'type': 'header', 'date': date, 'total': dayTotal});

      // Add Expense Items
      for (var expense in expenses) {
        listItems.add({
          'type': 'item',
          'category': expense['category'],
          'amount': expense['amount'],
        });
      }
    });

    final List<String> list = <String>[
      'This month',
      'Last month',
      'This year',
      'Last year',
    ];
    late String selectedValue = list.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Monety',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
      ),
      body: Center(
        child: Column(
          children: [
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
                        backgroundImage: AssetImage(
                          'assets/images/profile.jpg',
                        ),
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
                    initialSelection:
                        selectedValue, // Sets the default value on load
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
            Container(
              height: 300,
              width: 400,
              color: const Color.fromARGB(255, 52, 94, 163),
              child: Row(
                children: const [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Total Balance',
                          style: TextStyle(fontSize: 15, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Image(
                          image: AssetImage('assets/images/expense.jpg'),
                          height: 150,
                          width: 200,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
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

            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(
                  16.0,
                ), // Spacing around the list blocks
                itemCount: listItems.length,
                itemBuilder: (context, index) {
                  final item = listItems[index];

                  // Only act on header types to kick off a "Day Block"
                  if (item['type'] != 'header') {
                    return const SizedBox.shrink(); // Skip expense entries in the main loop
                  }

                  final String currentDate = item['date'];
                  final String currentTotal = item['total'].toString();

                  // Find all subsequent expense items belonging to this specific date block
                  final List<Map<String, dynamic>> subItems = [];
                  for (int i = index + 1; i < listItems.length; i++) {
                    if (listItems[i]['type'] == 'header')
                      break; // Stop when the next day hits
                    subItems.add(Map<String, dynamic>.from(listItems[i]));
                  }

                  return Container(
                    margin: const EdgeInsets.only(
                      bottom: 20.0,
                    ), // Space between day groups
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. Day Header Block
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date: $currentDate',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Total: \$$currentTotal',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Thin divider right below the header before elements start
                        if (subItems.isNotEmpty)
                          Divider(
                            color: Colors.grey.shade400,
                            thickness: 1.5,
                            height: 1.0,
                          ),

                        // 2. Expense Items List inside this Day Block
                        ListView.separated(
                          shrinkWrap: true, // Crucial inside Column
                          physics:
                              const NeverScrollableScrollPhysics(), // Disables nested scrolling conflict
                          itemCount: subItems.length,
                          separatorBuilder: (context, subIndex) => Divider(
                            color: Colors.grey.shade300,
                            thickness: 1.0,
                            height: 1.0,
                            indent:
                                72.0, // Aligns divider with text, skipping the avatar
                          ),
                          itemBuilder: (context, subIndex) {
                            final subItem = subItems[subIndex];
                            final String category = subItem['category'] ?? '';
                            final int amount = subItem['amount'] ?? 0;

                            return ListTile(
                              leading: const CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                  'assets/images/food.jpg',
                                ),
                              ),
                              title: Text(
                                category.isNotEmpty
                                    ? '${category[0].toUpperCase()}${category.substring(1)}'
                                    : '',
                              ),
                              subtitle: Text(
                                'Description of $category expense',
                              ),
                              trailing: Text(
                                '\$$amount',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
