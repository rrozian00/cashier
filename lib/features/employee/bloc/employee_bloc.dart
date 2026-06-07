import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../user/models/user_model.dart';
import '../repo/employee_repo.dart';
import '../../user/repositories/user_repository.dart';

part 'employee_event.dart';
part 'employee_state.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final UserRepository _userRepository = UserRepository();
  final EmployeeRepo _employeeRepo = EmployeeRepo();

  EmployeeBloc() : super(EmployeeInitial()) {
    //add
    on<EmployeeAdded>((event, emit) async {
      try {
        emit(EmployeeLoading());

        final createResult = await _employeeRepo.createEmployee(
          name: event.name,
          email: event.email,
          password: event.password,
          address: event.address,
          phone: event.phone,
          salary: event.salary,
        );

        if (createResult.isLeft()) {
          final error = createResult.fold(
            (l) => l,
            (r) => null,
          );

          emit(
            EmployeeError(
              message: error!.message,
            ),
          );

          return;
        }

        final employeesResult = await _employeeRepo.getEmployees();

        employeesResult.fold(
          (error) {
            emit(
              EmployeeError(
                message: error.message,
              ),
            );
          },
          (employees) {
            emit(
              EmployeeSuccess(
                employees: employees,
              ),
            );
          },
        );
      } catch (e) {
        emit(
          EmployeeError(
            message: e.toString(),
          ),
        );
      }
    });

    //get
    on<EmployeeFetched>(
      (event, emit) async {
        emit(EmployeeLoading());
        final employeesEither = await _employeeRepo.getEmployees();

        employeesEither.fold(
          (error) {
            emit(EmployeeError(message: error.message));
          },
          (employees) {
            emit(EmployeeSuccess(employees: employees));
          },
        );
      },
    );

    //edit
    on<EmployeeEdited>(
      (event, emit) async {
        emit(EmployeeLoading());
        final res = await _userRepository.editUser(
          user: event.user,
          newName: event.name,
          newAddress: event.address,
          newPhone: event.phone,
        );

        if (res.isLeft()) {
          emit(EmployeeError(message: res.fold((l) => l.message, (r) => "")));
          return;
        }

        if (res.isRight()) {
          final employeesEither = await _employeeRepo.getEmployees();
          employeesEither.fold(
            (error) {
              emit(EmployeeError(message: error.message));
            },
            (employees) {
              emit(EmployeeSuccess(employees: employees));
            },
          );
        }
      },
    );

    //delete
    on<EmployeeDeleted>(
      (event, emit) async {
        emit(EmployeeLoading());
        final res = await _employeeRepo.deleteEmployee(event.id);

        if (res.isLeft()) {
          emit(EmployeeError(message: res.fold((l) => l.message, (r) => "")));
          return;
        }

        if (res.isRight()) {
          final employeesEither = await _employeeRepo.getEmployees();
          employeesEither.fold(
            (error) {
              emit(EmployeeError(message: error.message));
            },
            (employees) {
              emit(EmployeeSuccess(employees: employees));
            },
          );
        }
      },
    );
  }
}
