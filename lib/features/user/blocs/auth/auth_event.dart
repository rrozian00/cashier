part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk cek status
final class AuthCheckStatusEvent extends AuthEvent {}

// Event untuk login
final class AuthLoginEvent extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginEvent({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

//Change Password
final class ChangePasswordPressed extends AuthEvent {
  final String email;
  final String oldPass;
  final String newPass;

  const ChangePasswordPressed({
    required this.email,
    required this.oldPass,
    required this.newPass,
  });

  @override
  List<Object?> get props => [
        email,
        oldPass,
        newPass,
      ];
}

// Event untuk logout
final class AuthLogoutEvent extends AuthEvent {}
