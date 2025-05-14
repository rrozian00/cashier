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

class StopWatchingProducts extends OrderEvent {}

class ClearCart extends OrderEvent {}

class _EmitError extends OrderEvent {
  final String message;
  const _EmitError(this.message);
}

class _EmitProductSuccess extends OrderEvent {
  final List<ProductModel> products;
  const _EmitProductSuccess(this.products);
}
