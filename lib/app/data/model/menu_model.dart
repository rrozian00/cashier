import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  String? id; // Ubah ke String agar sesuai dengan Firestore
  String? name;
  String? price;
  String? image;
  String? createdAt;

  MenuModel({
    this.id,
    this.name,
    this.price,
    this.image,
    this.createdAt,
  });

  // Konversi dari Map (SQLite)
  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
      createdAt: map['createdAt'],
    );
  }

  // Konversi ke Map (SQLite)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'image': image,
      'createdAt': createdAt,
    };
  }

  // Konversi dari JSON (Firestore)
  factory MenuModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return MenuModel(
      id: docId ?? json['id'], // Gunakan docId dari Firestore jika ada
      name: json['name'],
      price: json['price'],
      image: json['image'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate().toIso8601String()
          : json['createdAt'],
    );
  }

  // Konversi ke JSON (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'image': image,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  MenuModel copyWith({
    String? id,
    String? name,
    String? price,
    String? image,
    String? createdAt,
  }) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
