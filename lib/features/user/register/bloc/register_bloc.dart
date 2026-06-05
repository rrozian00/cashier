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
    final result =
        await userRepository.createUserToSupabase(event.user, event.password);
    if (result.isRight()) {
      emit(RegisterSuccessState(user: event.user));
    } else {
      emit(RegisterFailedState(
          message: result.fold((l) => l.message, (r) => "Unknown error")));
    }
  }
}
