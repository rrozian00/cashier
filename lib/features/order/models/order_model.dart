// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:cashier/features/menu/models/product_model.dart';

class OrderModel {
  String? id;
  String? name;
  List<ProductModel>? products;
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
    List<ProductModel>? products,
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
          ? List<ProductModel>.from(
              (map['products'] as List).map<ProductModel?>(
                (x) => ProductModel.fromMap(x as Map<String, dynamic>),
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

  String toJson() => json.encode(toMap());

  factory OrderModel.fromJson(String source) =>
      OrderModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OrderModel(id: $id, name: $name, products: $products, total: $total, refund: $refund, payment: $payment, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant OrderModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        listEquals(other.products, products) &&
        other.total == total &&
        other.refund == refund &&
        other.payment == payment &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        products.hashCode ^
        total.hashCode ^
        refund.hashCode ^
        payment.hashCode ^
        createdAt.hashCode;
  }
}
