part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

// Event untuk cek status
final class LoginVerificationChecked extends LoginEvent {}

final class PasswordVissibilityTogled extends LoginEvent {}

// Event untuk login
final class LoginSubmitted extends LoginEvent {
  final String email;
  final String password;

  const LoginSubmitted({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

// //Change Password
// final class ChangePasswordPressed extends AuthEvent {
//   final String email;
//   final String oldPass;
//   final String newPass;

//   const ChangePasswordPressed({
//     required this.email,
//     required this.oldPass,
//     required this.newPass,
//   });

//   @override
//   List<Object?> get props => [
//         email,
//         oldPass,
//         newPass,
//       ];
// }

// // Event untuk cek verification
// final class AuthVerificationRequested extends AuthEvent {}

// Event untuk kirim verification
// final class AuthSendVerification extends AuthEvent {}

// // Event untuk logout
// final class AuthLogoutEvent extends AuthEvent {}
