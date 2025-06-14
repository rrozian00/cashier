import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cashier/core/errors/failure.dart';
import 'package:cashier/core/utils/get_user_data.dart';
import 'package:equatable/equatable.dart';

import '../../models/user_model.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final authRepository = AuthRepository();
  final userRepository = UserRepository();

  AuthBloc() : super(UnauthenticatedState(true)) {
    on<AuthCheckStatusEvent>((event, emit) async {
      final user = await getUserData();
      final verif = await authRepository.checkVerification();
      if (user != null) {
        emit(AuthLoggedState(user, verif));
      } else {
        emit(UnauthenticatedState(true));
      }
    });

    on<AuthSendVerification>(
      (event, emit) async {
        emit(AuthLoadingState());
        await authRepository.sendVerification();
        final verif = await authRepository.checkVerification();
        final user = await getUserData();
        if (user != null) {
          emit(AuthLoggedState(user, verif));
        }
      },
    );

    on<AuthLoginEvent>(_onLogin);

    on<ChangePasswordPressed>(_onChangePass);

    on<AuthLogoutEvent>(_onLogout);
    on<SeePassword>(_onSeePassword);
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
    // await authRepository.logout();
    emit(UnauthenticatedState(true));
  }

  void _onSeePassword(SeePassword event, Emitter<AuthState> emit) {
    if (state is UnauthenticatedState) {
      final currenState = state as UnauthenticatedState;
      emit(UnauthenticatedState(!currenState.isObsecure));
    }
  }
}
