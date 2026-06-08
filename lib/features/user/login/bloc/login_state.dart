part of 'login_bloc.dart';

class LoginState extends Equatable {
  final bool obscure;
  final bool isLoading;
  final User? user;
  final String? message;

  const LoginState({
    this.obscure = true,
    this.isLoading = false,
    this.user,
    this.message,
  });

  LoginState copyWith({
    bool? obscure,
    bool? isLoading,
    User? user,
    String? message,
  }) =>
      LoginState(
        obscure: obscure ?? this.obscure,
        isLoading: isLoading ?? this.isLoading,
        user: user,
        message: message,
      );

  @override
  List<Object?> get props => [obscure, isLoading, user, message];
}
