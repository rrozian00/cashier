import 'package:bloc/bloc.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cashier/features/user/repositories/user_repository.dart';

import 'package:equatable/equatable.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final UserRepository _userRepository = UserRepository();

  EmployeeBloc() : super(EmployeeInitial()) {
    //add
    on<AddEmployeePressed>((event, emit) async {
      try {
        emit(EmployeeLoading());
        await _userRepository.createEmployee(event.employee, event.password);
        emit(EmployeeAddSuccess(employee: event.employee));
      } catch (e) {
        emit(EmployeeFailed(message: e.toString()));
      }
    });

    //get
    on<GetEmployeeRequested>(
      (event, emit) async {
        try {
          emit(EmployeeLoading());
          final employees = await _userRepository.getEmployees();
          emit(EmployeeGetSuccess(employees: employees));
        } catch (e) {
          emit(EmployeeFailed(message: e.toString()));
        }
      },
    );
  }
}
