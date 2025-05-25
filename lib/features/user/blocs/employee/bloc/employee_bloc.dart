import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';

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
          final employeesEither = await _userRepository.getEmployees();

          employeesEither.fold(
            (error) => error.message,
            (employees) {
              emit(EmployeeGetSuccess(employees: employees));
            },
          );
        } catch (e) {
          emit(EmployeeFailed(message: e.toString()));
        }
      },
    );

    //edit
    on<EditEmployeePressed>(
      (event, emit) async {
        emit(EmployeeLoading());
        await _userRepository.editUser(
          id: event.id,
          newSalary: event.salary,
          newName: event.name,
          newAddress: event.address,
          newPhone: event.phone,
        );
      },
    );

    //delete
    on<DeleteEmployeeRequested>(
      (event, emit) async {
        emit(EmployeeLoading());
        await _userRepository.deleteEmployee(event.id);
      },
    );
  }
}
