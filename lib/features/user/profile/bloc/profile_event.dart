part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfile extends ProfileEvent {
  final UserModel user;

  const GetProfile(this.user);

  @override
  List<Object> get props => [user];
}
