import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final userRepository = UserRepository();
  final authRepository = AuthRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequestedEvent>(_onRegister);
  }

  Future<void> _onRegister(
    RegisterRequestedEvent event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoadingState());
    await userRepository.createUser(event.user, event.password);
    emit(RegisterSuccessState(user: event.user));
  }
}
