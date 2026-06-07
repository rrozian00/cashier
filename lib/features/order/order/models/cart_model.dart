import '../../../product/models/product_model.dart';

class CartModel {
  final ProductModel product;
  // final int quantity;

  const CartModel({
    required this.product,
    // required this.quantity,
  });

  CartModel copyWith({
    ProductModel? product,
    int? quantity,
  }) {
    return CartModel(
      product: product ?? this.product,
      // quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'product': product.toMap(),
      // 'quantity': quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      product: ProductModel.fromMap(map['product'] as Map<String, dynamic>),
      // quantity: map['quantity'] as int,
    );
  }
}
