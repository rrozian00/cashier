part of 'order_bloc.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();

  @override
  List<Object?> get props => [];
}

class FetchProduct extends OrderEvent {}

class StopWatchingProducts extends OrderEvent {}

class AddToCart extends OrderEvent {
  final ProductModel product;

  const AddToCart({required this.product});

  @override
  List<Object?> get props => [product];
}

class AddToCartByBarcode extends OrderEvent {
  final String barcode;

  const AddToCartByBarcode({required this.barcode});

  @override
  List<Object?> get props => [barcode];
}

class AddToCartByTap extends OrderEvent {
  final ProductModel product;

  const AddToCartByTap({required this.product});

  @override
  List<Object?> get props => [product];
}

class RemoveFromCart extends OrderEvent {
  final ProductModel product;

  const RemoveFromCart({required this.product});

  @override
  List<Object?> get props => [product];
}

class IncrementCartItem extends OrderEvent {
  final ProductModel product;

  const IncrementCartItem({required this.product});

  @override
  List<Object?> get props => [product];
}

class DecrementCartItem extends OrderEvent {
  final ProductModel product;

  const DecrementCartItem({required this.product});

  @override
  List<Object?> get props => [product];
}

class ClearCart extends OrderEvent {}

class _EmitProductSuccess extends OrderEvent {
  final List<ProductModel> products;
  const _EmitProductSuccess({required this.products});
}

class _EmitError extends OrderEvent {
  final String message;
  const _EmitError({required this.message});
}

class UpdateCartItem extends OrderEvent {
  final ProductModel product;
  final int quantity;

  const UpdateCartItem({required this.product, required this.quantity});

  @override
  List<Object?> get props => [product, quantity];
}
