// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id; // Ubah ke String agar sesuai dengan Firestore
  String? barcode;
  String? name;
  String? price;
  String? image;
  String? publicId;
  int? quantity;
  Timestamp? createdAt;
  ProductModel({
    this.id,
    this.barcode,
    this.name,
    this.price,
    this.image,
    this.publicId,
    this.quantity,
    this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? barcode,
    String? name,
    String? price,
    String? image,
    String? publicId,
    int? quantity,
    Timestamp? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      publicId: publicId ?? this.publicId,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'barcode': barcode,
      'name': name,
      'price': price,
      'image': image,
      'publicId': publicId,
      'quantity': quantity,
      'createdAt': createdAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as String : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      publicId: map['publicId'] != null ? map['publicId'] as String : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) =>
      ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, barcode: $barcode, name: $name, price: $price, image: $image, publicId: $publicId, quantity: $quantity, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.barcode == barcode &&
        other.name == name &&
        other.price == price &&
        other.image == image &&
        other.publicId == publicId &&
        other.quantity == quantity &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        barcode.hashCode ^
        name.hashCode ^
        price.hashCode ^
        image.hashCode ^
        publicId.hashCode ^
        quantity.hashCode ^
        createdAt.hashCode;
  }
}
