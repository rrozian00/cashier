part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  @override
  List<Object> get props => [];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class ProductSuccess extends OrderState {
  final List<ProductModel> products;

  ProductSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

final class OrderError extends OrderState {
  final String message;

  OrderError({required this.message});

  @override
  List<Object> get props => [message];
}
