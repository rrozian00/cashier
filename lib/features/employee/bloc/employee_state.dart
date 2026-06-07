part of 'employee_bloc.dart';

sealed class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object?> get props => [];
}

final class EmployeeInitial extends EmployeeState {}

final class EmployeeLoading extends EmployeeState {}

// //ADD
// final class EmployeeAddSuccess extends EmployeeState {
//   final UserModel employee;

//   const EmployeeAddSuccess({required this.employee});

//   @override
//   List<Object> get props => [employee];
// }

//GET
final class EmployeeSuccess extends EmployeeState {
  final List<UserModel> employees;
  final String? message;

  const EmployeeSuccess({required this.employees, this.message});

  @override
  List<Object?> get props => [employees, message];
}

// // //DETAIL
// final class EmployeeDetailSuccess extends EmployeeState {
//   final UserModel employee;

//   const EmployeeDetailSuccess({required this.employee});

//   @override
//   List<Object> get props => [employee];
// }

//FAILED
final class EmployeeError extends EmployeeState {
  final String message;

  const EmployeeError({required this.message});

  @override
  List<Object> get props => [message];
}
