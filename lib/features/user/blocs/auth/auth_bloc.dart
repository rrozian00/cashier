import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/app_errors/failure.dart';
import '../../../../core/utils/get_user_data.dart';
import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepository = AuthRepository();
  final userRepository = UserRepository();

  AuthBloc() : super(UnauthenticatedState()) {
    on<AuthCheckStatusEvent>(_onAuthCheckStatusEvent);
    on<AuthSendVerification>(_onAuthSendVerification);
    on<AuthLoginEvent>(_onLogin);
    on<ChangePasswordPressed>(_onChangePass);
    on<AuthLogoutEvent>(_onLogout);
  }

  Future<void> _onAuthCheckStatusEvent(
    AuthCheckStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    final user = await getUserData();
    final verif = await authRepository.checkVerification();
    if (user != null) {
      emit(AuthLoggedState(user, verif));
    } else {
      emit(UnauthenticatedState());
    }
  }

  Future<void> _onAuthSendVerification(
    AuthSendVerification event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    // await authRepository.sendVerification();
    final verif = await authRepository.checkVerification();
    final user = await getUserData();
    if (user != null) {
      emit(AuthLoggedState(user, verif));
    }
  }

  Future<void> _onLogin(
    AuthLoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await userRepository.login(event.email, event.password);
    if (result.isLeft()) {
      final failure = result.swap().getOrElse(
            () => Failure("Login gagal"),
          );
      emit(AuthFailedState(failure.message));
      return;
    }
    final user = result.getOrElse(() => null);
    if (user == null) {
      emit(AuthFailedState("user null"));
      return;
    }

    final userEither = await userRepository.getUser(user.id);
    final userDoc = userEither.getOrElse(() => throw Exception("null"));
    final verif = user.emailConfirmedAt != null;
    emit(AuthLoggedState(userDoc, verif));
  }

  Future<void> _onChangePass(
    ChangePasswordPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    await authRepository.changePassword(
      email: event.email,
      newPassword: event.newPass,
    );
    emit(ChangePassSuccess());
  }

  Future<void> _onLogout(
    AuthLogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    await authRepository.logout();
    emit(UnauthenticatedState());
  }
}
