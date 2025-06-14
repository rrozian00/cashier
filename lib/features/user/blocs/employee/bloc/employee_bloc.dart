import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../models/user_model.dart';
import '../../../repositories/employee_repo.dart';
import '../../../repositories/user_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final UserRepository _userRepository = UserRepository();
  final EmployeeRepo _employeeRepo = EmployeeRepo();

  EmployeeBloc() : super(EmployeeInitial()) {
    //add
    on<AddEmployeePressed>((event, emit) async {
      try {
        emit(EmployeeLoading());
        await _employeeRepo.createEmployee(
            name: event.name,
            email: event.email,
            password: event.password,
            address: event.address,
            phone: event.phone,
            salary: event.salary);
        emit(EmployeeAddSuccess());
      } catch (e) {
        emit(EmployeeFailed(message: e.toString()));
      }
    });

    //get
    on<GetEmployeeRequested>(
      (event, emit) async {
        emit(EmployeeLoading());
        final employeesEither = await _employeeRepo.getEmployees();

        employeesEither.fold(
          (error) {
            emit(EmployeeFailed(message: error.message));
          },
          (employees) {
            emit(EmployeeGetSuccess(employees: employees));
          },
        );
      },
    );

    //edit
    on<EditEmployeePressed>(
      (event, emit) async {
        emit(EmployeeLoading());
        await _userRepository.editUser(
          id: event.id,
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
        await _employeeRepo.deleteEmployee(event.id);
      },
    );
  }
}
