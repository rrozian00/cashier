part of 'store_bloc.dart';

sealed class StoreEvent extends Equatable {
  const StoreEvent();

  @override
  List<Object> get props => [];
}

final class GetStoresList extends StoreEvent {}

final class UpdateStore extends StoreEvent {
  final String name;
  final String address;
  final String phone;

  const UpdateStore({
    required this.name,
    required this.address,
    required this.phone,
  });

  @override
  List<Object> get props => [name, address, phone];
}

final class AddStore extends StoreEvent {
  final String name;
  final String address;
  final String phone;
  final String logoUrl;

  const AddStore({
    required this.name,
    required this.address,
    required this.phone,
    required this.logoUrl,
  });

  @override
  List<Object> get props => [
        name,
        address,
        phone,
        logoUrl,
      ];
}
