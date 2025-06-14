part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

//Auth
final class UnauthenticatedState extends AuthState {
  final bool isObsecure;

  const UnauthenticatedState(this.isObsecure);

  UnauthenticatedState copyWith({
    bool? isObsecure,
  }) {
    return UnauthenticatedState(isObsecure ?? this.isObsecure);
  }

  @override
  List<Object> get props => [isObsecure];
}

//Login
final class AuthLoadingState extends AuthState {}

final class AuthLoggedState extends AuthState {
  final bool verification;
  final UserModel user;

  const AuthLoggedState(
    this.user,
    this.verification,
  );

  @override
  List<Object> get props => [
        user,
        verification,
      ];
}

// final class AuthSendedVerificationState extends AuthState {
//   final UserModel user;
//   final bool verification;

//   const AuthSendedVerificationState({
//     required this.verification,
//     required this.user,
//   });

//   @override
//   List<Object> get props => [verification, user];
// }

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
