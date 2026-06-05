part of 'edit_profile_bloc.dart';

sealed class EditProfileState extends Equatable {
  const EditProfileState();

  @override
  List<Object> get props => [];
}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileSuccess extends EditProfileState {}

final class EditProfileError extends EditProfileState {
  final String message;

  const EditProfileError({required this.message});
}
