part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

final class RegisterInitial extends RegisterState {}

final class RegisterLoadingState extends RegisterState {}

final class EditSuccessState extends RegisterState {}

final class RegisterSuccessState extends RegisterState {
  final UserModel user;

  const RegisterSuccessState({required this.user});

  @override
  List<Object?> get props => [user];
}

final class RegisterFailedState extends RegisterState {}
