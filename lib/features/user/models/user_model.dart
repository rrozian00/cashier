// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String? storeId;
  String? email;
  String? name;
  String? address;
  String? salary;
  String? role;
  String? phoneNumber;
  String? photo;
  String? createdAt;

  UserModel({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'address': address,
      'salary': salary,
      'role': role,
      'phoneNumber': phoneNumber,
      'photo': photo,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      address: json['address'],
      salary: json['salary'],
      role: json['role'],
      phoneNumber: json['phoneNumber'],
      photo: json['photo'],
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate().toIso8601String()
          : json['createdAt'],
    );
  }

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
    String? createdAt,
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
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, storeId: $storeId, email: $email, name: $name, address: $address, salary: $salary, role: $role, phoneNumber: $phoneNumber, photo: $photo, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.storeId == storeId &&
        other.email == email &&
        other.name == name &&
        other.address == address &&
        other.salary == salary &&
        other.role == role &&
        other.phoneNumber == phoneNumber &&
        other.photo == photo &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        storeId.hashCode ^
        email.hashCode ^
        name.hashCode ^
        address.hashCode ^
        salary.hashCode ^
        role.hashCode ^
        phoneNumber.hashCode ^
        photo.hashCode ^
        createdAt.hashCode;
  }
}
