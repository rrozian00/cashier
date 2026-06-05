part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileFetched extends ProfileEvent {}

class ChangePasswordSubmitted extends ProfileEvent {
  final String email;
  final String oldPass;
  final String newPass;

  const ChangePasswordSubmitted({
    required this.email,
    required this.oldPass,
    required this.newPass,
  });

  @override
  List<Object> get props => [email, oldPass, newPass];
}

class LogoutSubmitted extends ProfileEvent {}

class VerificationSent extends ProfileEvent {}
