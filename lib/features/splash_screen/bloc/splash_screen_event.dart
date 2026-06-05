part of 'splash_screen_bloc.dart';

sealed class SplashScreenEvent extends Equatable {
  const SplashScreenEvent();

  @override
  List<Object> get props => [];
}

final class AuthenticationChecked extends SplashScreenEvent {}
