import 'package:flutter/material.dart';
import 'package:flutter_expense/screen/add_expense.dart';
import 'package:flutter_expense/screen/expense_tracker.dart';
import 'package:flutter_expense/screen/login.dart';
import 'package:flutter_expense/screen/register.dart';
import 'package:flutter_expense/screen/statistics.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: ExpenseTracker()),
    Center(child: Statistics()),
    Center(child: AddExpense()),
    Center(child: Text('Notification Page')),  
    
  ];


  // Helper method to change tabs
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: (){
                  _onItemTapped(0);
              }, 
              color: _selectedIndex == 0 ? Colors.pink : Colors.grey,
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: (){
                  _onItemTapped(1);
              }, 
              color: _selectedIndex == 1 ? Colors.pink : Colors.grey,
              // Add your navigation logic here
            ),
            IconButton(
              icon: Icon(Icons.add),
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(Colors.pink),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                ),
              ),
              onPressed: (){
                  _onItemTapped(2);
              }, // Add your navigation logic here
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: (){
                  _onItemTapped(3);
              }, 
              color: _selectedIndex == 3 ? Colors.pink : Colors.grey,
              // Add your navigation logic here
            ),
            IconButton(
              icon: Icon(Icons.person),
              color: _selectedIndex == 4 ? Colors.pink : Colors.grey,
              onPressed: (){
                  //TODO: clear user session and navigate to login page
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
              }, // Add your navigation logic here
            ),
          ],
        ),
      ),
    );
  }
}