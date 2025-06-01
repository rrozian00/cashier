import 'dart:convert';

import 'package:equatable/equatable.dart';

import '../../../product/models/product_model.dart';

class CartModel extends Equatable {
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

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) =>
      CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [product];
}
