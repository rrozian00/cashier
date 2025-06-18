part of 'store_bloc.dart';

sealed class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

final class GetStoresList extends StoreEvent {}

final class MakeStoreActive extends StoreEvent {
  final String id;

  const MakeStoreActive({required this.id});
  @override
  List<Object> get props => [id];
}

final class UpdateStore extends StoreEvent {
  final String id;
  final String name;
  final String address;
  final String phone;

  const UpdateStore({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  List<Object> get props => [id, name, address, phone];
}

final class AddStore extends StoreEvent {
  final String category;
  final String name;
  final String address;
  final String phone;
  final String logoUrl;

  const AddStore({
    required this.category,
    required this.name,
    required this.address,
    required this.phone,
    required this.logoUrl,
  });

  @override
  List<Object> get props => [
        category,
        name,
        address,
        phone,
        logoUrl,
      ];
}
