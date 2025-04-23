import 'package:bloc/bloc.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cashier/features/user/repositories/auth_repository.dart';
import 'package:cashier/features/user/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final userRepository = UserRepository();
  final authRepository = AuthRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequestedEvent>(_onRegister);
    on<EditRequestedEvent>(_onEdit);
  }

  Future<void> _onRegister(
    RegisterRequestedEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());
    await userRepository.createUser(event.user, event.password);
    emit(RegisterSuccessState(user: event.user));
  }

  void _onEdit(
    EditRequestedEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());
    await userRepository.editUser(
        newName: event.name, newAddress: event.address, newPhone: event.phone);
    emit(EditSuccessState());
  }
}
