import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
      final user = await authRepository.getCurrentUser();
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
        final user = await authRepository.getCurrentUser();
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
    try {
      final user = await authRepository.login(event.email, event.password);
      if (user != null) {
        String userId = user.uid;
        final userEither = await userRepository.getUser(userId);
        final userDoc = userEither.getOrElse(
          () => throw Exception("Unexpected null"),
        );

        final verif = await authRepository.checkVerification();

        emit(AuthLoggedState(userDoc, verif));

        if (userDoc.role == 'owner') {
          debugPrint("Login sebagai Owner");
        } else if (userDoc.role == 'employee') {
          debugPrint("Login sebagai Karyawan");
        }
      }
    } on FirebaseException catch (e) {
      emit(AuthFailedState(e.message ?? "Firebase error"));
    } catch (e) {
      emit(AuthFailedState(e.toString()));
    }
  }

  Future<void> _onChangePass(
    ChangePasswordPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    await authRepository.changePassword(
      email: event.email,
      oldPassword: event.oldPass,
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
    emit(UnauthenticatedState(true));
  }

  void _onSeePassword(SeePassword event, Emitter<AuthState> emit) {
    if (state is UnauthenticatedState) {
      final currenState = state as UnauthenticatedState;
      emit(UnauthenticatedState(!currenState.isObsecure));
    }
  }
}
