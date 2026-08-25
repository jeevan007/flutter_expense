import 'package:flutter/material.dart';
import 'package:flutter_expense/db/db_helpher.dart';
import 'package:flutter_expense/model/user.dart';
import 'package:flutter_expense/screen/login.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmPasswordController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    void clearControllers() {
      usernameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Register')),
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
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Username cannot be empty';
                        }
                        return null;
                      },
                    ),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirm Password cannot be empty';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        DbHelpher dbHelper = DbHelpher.instance;
                        User newUser = User(
                          user_name: usernameController.text,
                          user_email: emailController.text,
                          user_password: passwordController.text,
                          user_created_at: DateTime.now().toIso8601String(),
                        );
                        Future<bool> success = dbHelper.insertUser(table: DbHelpher.TABLE_USER, user: newUser);
                        success.then((value) {
                          if (value) {
                            clearControllers();
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const Login()),
                            );// Navigate back to the previous screen after successful registration
                          }
                        });
                      }
                    },
                    child: Text('Register'),
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
