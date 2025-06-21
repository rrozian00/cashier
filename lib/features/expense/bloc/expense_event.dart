part of 'expense_bloc.dart';

sealed class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

final class ExpenseGetRequested extends ExpenseEvent {}

final class ExpenseAddRequested extends ExpenseEvent {
  final BuildContext context;
  final String date;
  final String pay;

  const ExpenseAddRequested({
    required this.context,
    required this.date,
    required this.pay,
  });
  @override
  List<Object> get props => [context, date, pay];
}
