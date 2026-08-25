import 'package:flutter/material.dart';
import 'package:flutter_expense/db/db_helpher.dart';
import 'package:flutter_expense/screen/bottom_navbar.dart';
import 'package:flutter_expense/screen/register.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: Text('Email Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    'Welcome to Expense Tracker',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email cannot be empty';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        if (!RegExp(
                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$',
                        ).hasMatch(value)) {
                          return 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        DbHelpher dbHelper = DbHelpher.instance;
                        dbHelper.getUserByEmail(table: DbHelpher.TABLE_USER, email: emailController.text).then((user) {
                          print(user?.toMap());
                          if (user != null && user.user_password == passwordController.text) {
                            
                            // Navigate to the next screen or perform any other action
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Login successful!')),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const BottomNavBar()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid email or password')),
                            );
                          }
                        });
                      }
                    },
                    child: Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to the registration screen
                      Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Register()),
                            );
                    },
                    child: Text('Don\'t have an account? Register here'),
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
