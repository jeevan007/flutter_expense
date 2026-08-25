import 'dart:io';

import 'package:flutter_expense/model/expense.dart';
import 'package:flutter_expense/model/user.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelpher {
  DbHelpher._privateConstructor();

  static DbHelpher instance = DbHelpher._privateConstructor();

  Database? _database;

  static const String DB_NAME = "expenseDB.db";

  static const String TABLE_Expense = "expense";
  static const String EXPENSE_ID = "expense_id";
  static const String EXPENSE_TITLE = "expense_title";
  static const String EXPENSE_DESC = "expense_desc";
  static const String EXPENSE_AMOUNT = "expense_amount";
  static const String EXPENSE_CATEGORY = "expense_category";
  static const String EXPENSE_DATE = "expense_date";
  static const String EXPENSE_TYPE = "expense_type";
  static const String EXPENSE_CREATED_AT = "expense_created_at";

  static const String TABLE_USER = "user";
  static const String USER_ID = "user_id";
  static const String USER_NAME = "user_name";
  static const String USER_EMAIL = "user_email";
  static const String USER_PASSWORD = "user_password";
  static const String USER_CREATED_AT = "user_created_at";

  Future<Database> initDB() async {
    return _database ??= await openDB();
  }

  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();

    String dbPath = join(appDir.path, DB_NAME);

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table $TABLE_Expense($EXPENSE_ID integer primary key autoincrement, $EXPENSE_DESC text not null, $EXPENSE_AMOUNT real not null, $EXPENSE_CATEGORY text not null, $EXPENSE_DATE date not null, $EXPENSE_TYPE integer not null)"
        );
        db.execute(
          "create table $TABLE_USER($USER_ID integer primary key autoincrement, $USER_NAME text not null, $USER_EMAIL text not null, $USER_PASSWORD text not null, $USER_CREATED_AT text not null)"
        );
      },
    );
  }

  Future<bool> insertExpense({required String table, required Expense expense}) async {
    Database db = await initDB();
    int result = await db.insert(table, expense.toMap());
    return result > 0;
  }

  Future<bool> insertUser({required String table, required User user}) async {
    Database db = await initDB();
    int result = await db.insert(table, user.toMap());
    return result > 0;
  }

  Future<List<Expense>> getAllExpenses({required String table}) async {
    Database db = await initDB();
    List<Map<String, dynamic>> result = await db.query(table);
    return result.map((e) => Expense.fromMap(e)).toList();
  }

  Future<User?> getUserByEmail({required String table, required String email}) async {
    Database db = await initDB();
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: '$USER_EMAIL = ?',
      whereArgs: [email], 
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  Future<bool> getAllExpensesForMonth({required String table, required int month, required int year}) async {
    Database db = await initDB();
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: 'strftime("%m", $EXPENSE_DATE) = ? AND strftime("%Y", $EXPENSE_DATE) = ?',
      whereArgs: [month.toString().padLeft(2, '0'), year.toString()],
    );
    return result.isNotEmpty;
  }

  Future<bool> getAllExpensesForYear({required String table, required int year}) async {
    Database db = await initDB();
    List<Map<String, dynamic>> result = await db.query(
      table,
      where: 'strftime("%Y", $EXPENSE_DATE) = ?',
      whereArgs: [year.toString()],
    );
    return result.isNotEmpty;
  }

}
