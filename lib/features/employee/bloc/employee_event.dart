part of 'employee_bloc.dart';

sealed class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

final class EmployeeAdded extends EmployeeEvent {
  final String name;
  final String email;
  final String password;
  final String address;
  final String phone;
  final String salary;

  const EmployeeAdded({
    required this.name,
    required this.email,
    required this.password,
    required this.address,
    required this.phone,
    required this.salary,
  });

  @override
  List<Object> get props => [
        name,
        email,
        password,
        address,
        phone,
        salary,
      ];
}

final class EmployeeEdited extends EmployeeEvent {
  final UserModel user;
  final String name;
  final String address;
  final String phone;
  final String salary;

  const EmployeeEdited(
      {required this.user,
      required this.name,
      required this.address,
      required this.phone,
      required this.salary});
  @override
  List<Object> get props => [
        user,
        name,
        address,
        phone,
        salary,
      ];
}

final class EmployeeDeleted extends EmployeeEvent {
  final String id;

  const EmployeeDeleted(this.id);

  @override
  List<Object> get props => [id];
}

final class EmployeeFetched extends EmployeeEvent {}
