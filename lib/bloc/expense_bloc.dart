import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expense/bloc/expense_event.dart';
import 'package:flutter_expense/bloc/expense_state.dart';
import 'package:flutter_expense/db/db_helpher.dart';
import 'package:flutter_expense/model/expense.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<FetchExpenses>((event, emit) async {
      emit(ExpenseLoading());
      try {
        // Simulate fetching expenses from a database or API
        await Future.delayed(Duration(seconds: 2));
        List<Expense> expenses = await DbHelpher.instance.getAllExpenses(
          table: DbHelpher.TABLE_Expense,
        ); // Replace with actual data fetching logic
        emit(ExpenseLoaded(expenses));
      } catch (e) {
        emit(ExpenseError('Failed to fetch expenses'));
      }
    });
  }
}
