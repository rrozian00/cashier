part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

//Auth
final class UnauthenticatedState extends AuthState {}

//Login
final class AuthLoadingState extends AuthState {}

final class AuthLoggedState extends AuthState {
  final UserModel user;
  const AuthLoggedState(this.user);

  @override
  List<Object> get props => [user];
}

//Logout
final class AuthLogoutState extends AuthState {}

//Failed
final class AuthFailedState extends AuthState {
  final String message;
  const AuthFailedState(this.message);

  @override
  List<Object> get props => [message];
}

//
final class ChangePassSuccess extends AuthState {}
