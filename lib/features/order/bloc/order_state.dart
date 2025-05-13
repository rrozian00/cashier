part of 'order_bloc.dart';

sealed class OrderState extends Equatable {
  final List<Map<String, dynamic>> cart;
  final int totalHarga;
  final int jumlahBayar;
  final int kembalian;
  final String displayText;

  const OrderState({
    this.cart = const [],
    this.totalHarga = 0,
    this.jumlahBayar = 0,
    this.kembalian = 0,
    this.displayText = '',
  });

  @override
  List<Object> get props =>
      [cart, totalHarga, jumlahBayar, kembalian, displayText];
}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class ProductSuccess extends OrderState {
  final List<ProductModel> products;

  const ProductSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

class OrderLoaded extends OrderState {
  final List<ProductModel> products;

  const OrderLoaded({
    required this.products,
    super.cart,
    super.totalHarga,
    super.jumlahBayar,
    super.kembalian,
    super.displayText,
  });

  OrderLoaded copyWith({
    List<ProductModel>? products,
    List<Map<String, dynamic>>? cart,
    int? totalHarga,
    int? jumlahBayar,
    int? kembalian,
    String? displayText,
  }) {
    return OrderLoaded(
      products: products ?? this.products,
      cart: cart ?? this.cart,
      totalHarga: totalHarga ?? this.totalHarga,
      jumlahBayar: jumlahBayar ?? this.jumlahBayar,
      kembalian: kembalian ?? this.kembalian,
      displayText: displayText ?? this.displayText,
    );
  }

  @override
  List<Object> get props => [products, ...super.props];
}

final class OrderError extends OrderState {
  final String message;

  const OrderError({required this.message});

  @override
  List<Object> get props => [message];
}
