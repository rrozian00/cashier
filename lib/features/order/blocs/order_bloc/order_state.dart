part of 'order_bloc.dart';

abstract class OrderState extends Equatable {
  const OrderState();

  @override
  List<Object?> get props => [];
}

class OrderInitial extends OrderState {}

class OrderLoading extends OrderState {}

class OrderError extends OrderState {
  final String message;
  const OrderError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProductLoaded extends OrderState {
  final List<ProductModel> products;
  const ProductLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class OrderCartState extends OrderState {
  final List<CartModel> cart;
  final int totalPrice;

  const OrderCartState({
    required this.cart,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [cart, totalPrice];
}
