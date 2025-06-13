part of 'store_bloc.dart';

sealed class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object> get props => [];
}

final class StoreInitial extends StoreState {}

final class StoreLoading extends StoreState {}

final class AddStoreSuccess extends StoreState {}

final class UpdateStoreSuccess extends StoreState {}

final class GetStoreSuccess extends StoreState {
  final List<StoreModel> stores;

  const GetStoreSuccess({required this.stores});
  @override
  List<Object> get props => [stores];
}

final class StoreError extends StoreState {
  final String message;

  const StoreError({required this.message});
  @override
  List<Object> get props => [message];
}
