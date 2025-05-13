part of 'order_bloc.dart';

sealed class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object> get props => [];
}

class Fetchroduct extends OrderEvent {}

class AddToCart extends OrderEvent {
  final ProductModel product;

  const AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveToCart extends OrderEvent {}

class ClearCart extends OrderEvent {}
