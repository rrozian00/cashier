part of 'edit_user_bloc.dart';

sealed class EditUserState extends Equatable {
  const EditUserState();

  @override
  List<Object> get props => [];
}

final class EditUserInitial extends EditUserState {}

final class EditUserLoading extends EditUserState {}

final class EditUserSuccess extends EditUserState {}

final class EditUserError extends EditUserState {
  final String message;

  const EditUserError({required this.message});
}
