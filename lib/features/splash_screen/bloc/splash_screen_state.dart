part of 'splash_screen_bloc.dart';

sealed class SplashScreenState extends Equatable {
  const SplashScreenState();

  @override
  List<Object> get props => [];
}

final class SplashScreenInitial extends SplashScreenState {}

final class AuthenticationSuccess extends SplashScreenState {}

final class AuthenticationError extends SplashScreenState {
  final String message;

  const AuthenticationError({required this.message});

  @override
  List<Object> get props => [message];
}
