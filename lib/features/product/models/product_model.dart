import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? id;
  String? barcode;
  String? category;
  String? name;
  String? price;
  String? image;
  String? publicId;
  Timestamp? registerDate;
  Timestamp? expiredDate;
  int? quantity;
  Timestamp? createdAt;
  ProductModel({
    this.id,
    this.barcode,
    this.category,
    this.name,
    this.price,
    this.image,
    this.publicId,
    this.registerDate,
    this.expiredDate,
    this.quantity,
    this.createdAt,
  });

  ProductModel copyWith({
    String? id,
    String? barcode,
    String? category,
    String? name,
    String? price,
    String? image,
    String? publicId,
    Timestamp? registerDate,
    Timestamp? expiredDate,
    int? quantity,
    Timestamp? createdAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      publicId: publicId ?? this.publicId,
      registerDate: registerDate ?? this.registerDate,
      expiredDate: expiredDate ?? this.expiredDate,
      quantity: quantity ?? this.quantity,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'barcode': barcode,
      'category': category,
      'name': name,
      'price': price,
      'image': image,
      'publicId': publicId,
      'registerDate': registerDate,
      'expiredDate': expiredDate,
      'quantity': quantity,
      'createdAt': createdAt,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as String : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      publicId: map['publicId'] != null ? map['publicId'] as String : null,
      registerDate:
          map['registerDate'] != null ? map['registerDate'] as Timestamp : null,
      expiredDate:
          map['expiredDate'] != null ? map['expiredDate'] as Timestamp : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }
}
