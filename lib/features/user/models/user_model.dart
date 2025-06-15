import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id;
  final String? storeId;
  final String? email;
  final String? name;
  final String? address;
  final String? salary;
  final String? role;
  final String? phoneNumber;
  final String? photo;
  final Timestamp? createdAt;

  const UserModel({
    this.id,
    this.storeId,
    this.email,
    this.name,
    this.address,
    this.salary,
    this.role,
    this.phoneNumber,
    this.photo,
    this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? storeId,
    String? email,
    String? name,
    String? address,
    String? salary,
    String? role,
    String? phoneNumber,
    String? photo,
    Timestamp? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      storeId: storeId ?? this.storeId,
      email: email ?? this.email,
      name: name ?? this.name,
      address: address ?? this.address,
      salary: salary ?? this.salary,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photo: photo ?? this.photo,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'storeId': storeId,
      'email': email,
      'name': name,
      'address': address,
      'salary': salary,
      'role': role,
      'phoneNumber': phoneNumber,
      'photo': photo,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] != null ? map['id'] as String : null,
      storeId: map['storeId'] != null ? map['storeId'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      address: map['address'] != null ? map['address'] as String : null,
      salary: map['salary'] != null ? map['salary'] as String : null,
      role: map['role'] != null ? map['role'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }
}
