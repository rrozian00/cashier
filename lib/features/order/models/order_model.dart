import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  String? id;
  String? name;
  String? quantity;
  String? price;
  String? image;
  String? total;
  String? payment;
  String? refund;
  String? createdAt;

  OrderModel({
    this.id,
    this.name,
    this.quantity,
    this.price,
    this.image,
    this.total,
    this.payment,
    this.refund,
    this.createdAt,
  });

  // Konversi dari JSON ke Model (untuk menerima data dari Firestore)
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      image: json['image'],
      total: json['total'],
      payment: json['payment'],
      refund: json['refund'],
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt'] as Timestamp
          : json['createdAt'],
    );
  }

  // Konversi dari Model ke JSON (untuk penyimpanan di Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'image': image,
      'total': total,
      'payment': payment,
      'refund': refund,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // CopyWith untuk membuat salinan objek dengan perubahan
  OrderModel copyWith({
    String? id,
    String? name,
    String? quantity,
    String? price,
    String? image,
    String? total,
    String? payment,
    String? refund,
    dynamic createdAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      image: image ?? this.image,
      total: total ?? this.total,
      payment: payment ?? this.payment,
      refund: refund ?? this.refund,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
