part of 'employee_bloc.dart';

sealed class EmployeeEvent extends Equatable {
  const EmployeeEvent();

  @override
  List<Object> get props => [];
}

final class AddEmployeePressed extends EmployeeEvent {
  final UserModel employee;
  final String password;

  const AddEmployeePressed({
    required this.employee,
    required this.password,
  });

  @override
  List<Object> get props => [employee, password];
}

final class EditEmployeePressed extends EmployeeEvent {
  final String name;
  final String address;
  final String phone;
  final String salary;

  const EditEmployeePressed(
      {required this.name,
      required this.address,
      required this.phone,
      required this.salary});
  @override
  List<Object> get props => [
        name,
        address,
        phone,
        salary,
      ];
}

final class GetEmployeeRequested extends EmployeeEvent {
  const GetEmployeeRequested();

  @override
  List<Object> get props => [];
}
