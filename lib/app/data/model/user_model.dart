import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
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
}
