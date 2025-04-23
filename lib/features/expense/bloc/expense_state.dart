part of 'expense_bloc.dart';

sealed class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

final class ExpenseInitial extends ExpenseState {}

final class ExpenseLoading extends ExpenseState {}

//GET
final class ExpenseGetSucces extends ExpenseState {
  final List<ExpenseModel> expenses;

  const ExpenseGetSucces({required this.expenses});

  @override
  List<Object> get props => [expenses];
}

//ADD
final class ExpenseAddSucces extends ExpenseState {}

//UPDATE
final class ExpenseUpdateSucces extends ExpenseState {}

final class ExpenseFailed extends ExpenseState {
  final String message;

  const ExpenseFailed({required this.message});

  @override
  List<Object> get props => [message];
}
