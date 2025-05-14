import 'package:bloc/bloc.dart';
import '../models/expense_model.dart';
import '../repositories/expense_repository.dart';
import 'package:equatable/equatable.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repo = ExpenseRepository();

  ExpenseBloc() : super(ExpenseInitial()) {
    //GET
    on<ExpenseGetRequested>((event, emit) async {
      emit(ExpenseLoading());
      final expenses = await repo.getExpense();
      emit(ExpenseGetSucces(expenses: expenses));
    });
    //ADD
    on<ExpenseAddRequested>((event, emit) async {
      emit(ExpenseLoading());
      await repo.insertExpense(date: event.date, pay: event.pay);
      emit(ExpenseAddSucces());
    });
  }
}
