part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeSuccess extends HomeState {
  final UserModel user;
  final StoreModel store;

  const HomeSuccess({required this.user, required this.store});

  @override
  List<Object> get props => [
        user,
        store,
      ];
}

final class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});
  @override
  List<Object> get props => [message];
}
