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

  LoginBloc() : super(LoginInitial()) {
    on<LoginSubmitted>(_onLogin);
    on<PasswordVissibilityTogled>(_onTogglePasswordVisibility);
  }
  Future<void> _onTogglePasswordVisibility(
    PasswordVissibilityTogled event,
    Emitter<LoginState> emit,
  ) async {
    if (state is LoginInitial) {
      final currentState = state as LoginInitial;
      emit(LoginInitial(obsecure: !currentState.obsecure));
    }
  }

  Future<void> _onLogin(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());

    final result = await authRepository.login(event.email, event.password);
    result.fold(
      (err) => emit(LoginError(err.message)),
      (user) => emit(LoginSuccess(user)),
    );
  }

  // Future<void> _onAuthCheckStatusEvent(
  //   AuthCheckStatusEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   final user = await getUserData();
  //   final verif = await authRepository.checkVerification();
  //   if (user != null) {
  //     emit(AuthLoggedState(user, verif));
  //   } else {
  //     emit(UnauthenticatedState());
  //   }
  // }

  // Future<void> _onAuthSendVerification(
  //   AuthSendVerification event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoadingState());
  //   // await authRepository.sendVerification();
  //   final verif = await authRepository.checkVerification();
  //   // final user = await getUserData();
  //   final user = await userRepository.getUserDataFromSupabase();
  //   if (user.isRight()) {
  //     emit(AuthLoggedState(
  //         user.getOrElse(() => throw Exception("null")), verif));
  //   } else {
  //     emit(UnauthenticatedState());
  //   }
  // }

  // Future<void> _onChangePass(
  //   ChangePasswordPressed event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoadingState());
  //   await authRepository.changePassword(
  //     email: event.email,
  //     newPassword: event.newPass,
  //   );
  //   emit(ChangePassSuccess());
  // }

  // Future<void> _onLogout(
  //   AuthLogoutEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   emit(AuthLoadingState());
  //   await authRepository.logout();
  //   emit(UnauthenticatedState());
  // }
}
