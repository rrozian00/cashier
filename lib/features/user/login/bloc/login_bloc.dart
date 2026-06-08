import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final authRepository = AuthRepository();
  final userRepository = UserRepository();

  LoginBloc() : super(LoginState()) {
    on<PasswordVisibilityTogled>((event, emit) {
      emit(state.copyWith(obscure: !state.obscure));
    });
    on<LoginSubmitted>(_onLogin);
  }

  Future<void> _onLogin(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await authRepository.login(event.email, event.password);
    result.fold(
      (err) => emit(state.copyWith(message: err.message, isLoading: false)),
      (user) => emit(state.copyWith(user: user, isLoading: false)),
    );
  }
}
