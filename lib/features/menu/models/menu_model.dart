// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class MenuModel {
  String? id; // Ubah ke String agar sesuai dengan Firestore
  String? barcode;
  String? name;
  String? price;
  String? image;
  String? createdAt;
  MenuModel({
    this.id,
    this.barcode,
    this.name,
    this.price,
    this.image,
    this.createdAt,
  });

  MenuModel copyWith({
    String? id,
    String? barcode,
    String? name,
    String? price,
    String? image,
    String? createdAt,
  }) {
    return MenuModel(
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
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
      'createdAt': createdAt,
    };
  }

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      id: map['id'] != null ? map['id'] as String : null,
      barcode: map['barcode'] != null ? map['barcode'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MenuModel.fromJson(String source) =>
      MenuModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'MenuModel(id: $id, barcode: $barcode, name: $name, price: $price, image: $image, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant MenuModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.barcode == barcode &&
        other.name == name &&
        other.price == price &&
        other.image == image &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        barcode.hashCode ^
        name.hashCode ^
        price.hashCode ^
        image.hashCode ^
        createdAt.hashCode;
  }
}
