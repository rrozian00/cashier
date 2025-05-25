import 'package:cashier/features/order/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  String? name;
  List<CartModel>? products;
  String? total;
  String? refund;
  String? payment;
  Timestamp? createdAt;
  OrderModel({
    this.id,
    this.name,
    this.products,
    this.total,
    this.refund,
    this.payment,
    this.createdAt,
  });

  OrderModel copyWith({
    String? id,
    String? name,
    List<CartModel>? products,
    String? total,
    String? refund,
    String? payment,
    Timestamp? createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      products: products ?? this.products,
      total: total ?? this.total,
      refund: refund ?? this.refund,
      payment: payment ?? this.payment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'products': products?.map((x) => x.toMap()).toList(),
      'total': total,
      'refund': refund,
      'payment': payment,
      'createdAt': createdAt,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      products: map['products'] != null
          ? List<CartModel>.from(
              (map['products'] as List).map<CartModel?>(
                (x) => CartModel.fromMap(x as Map<String, dynamic>),
              ),
            )
          : null,
      total: map['total'] != null ? map['total'] as String : null,
      refund: map['refund'] != null ? map['refund'] as String : null,
      payment: map['payment'] != null ? map['payment'] as String : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }
}
