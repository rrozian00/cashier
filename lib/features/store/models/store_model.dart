import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String? id;
  String? name;
  String? ownerId;
  String? address;
  String? phone;
  String? logoUrl;
  String? category;
  bool? isActive;
  List<dynamic>? employees;
  Timestamp? createdAt;

  StoreModel({
    this.id,
    this.name,
    this.ownerId,
    this.address,
    this.phone,
    this.logoUrl,
    this.category,
    this.isActive,
    this.employees,
    this.createdAt,
  });

  StoreModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? address,
    String? phone,
    String? logoUrl,
    String? category,
    bool? isActive,
    List<dynamic>? employees,
    Timestamp? createdAt,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      logoUrl: logoUrl ?? this.logoUrl,
      category: category ?? this.category,
      isActive: isActive ?? this.isActive,
      employees: employees ?? this.employees,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'address': address,
      'phone': phone,
      'logoUrl': logoUrl,
      'category': category,
      'isActive': isActive,
      'employees': employees,
      'createdAt': createdAt,
    };
  }

  factory StoreModel.fromMap(Map<String, dynamic> map) {
    return StoreModel(
      id: map['id'] != null ? map['id'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      ownerId: map['ownerId'] != null ? map['ownerId'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      logoUrl: map['logoUrl'] != null ? map['logoUrl'] as String : null,
      category: map['category'] != null ? map['category'] as String : null,
      isActive: map['isActive'] != null ? map['isActive'] as bool : null,
      employees:
          map['employees'] != null ? (map['employees'] as List<dynamic>) : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }
}
