part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

final class LoginInitial extends LoginState {
  final bool obsecure;

  const LoginInitial({this.obsecure = true});

  @override
  List<Object> get props => [obsecure];
}

//Login
final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  // final bool verification;
  final User user;

  const LoginSuccess(
    this.user,
    // this.verification,
  );

  @override
  List<Object> get props => [
        user,
        // verification,
      ];
}

//Failed
final class LoginError extends LoginState {
  final String message;
  const LoginError(this.message);

  @override
  List<Object> get props => [message];
}

// //Login
// final class UnauthenticatedState extends LoginState {
//   final bool obsecure;
//   const UnauthenticatedState({this.obsecure = true});

//   @override
//   List<Object> get props => [obsecure];
// }

// final class LoginSendedVerificationState extends LoginState {
//   final UserModel user;
//   final bool verification;

//   const LoginSendedVerificationState({
//     required this.verification,
//     required this.user,
//   });

//   @override
//   List<Object> get props => [verification, user];
// }

// //Logout
// final class LoginLogoutState extends LoginState {}

//
// final class ChangePassSuccess extends LoginState {}
