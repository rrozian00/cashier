// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class StoreModel {
  String? id;
  String? name;
  String? ownerId;
  String? address;
  String? phone;
  String? logoUrl;
  String? createdAt;
  List<dynamic>? employees;

  StoreModel({
    this.id,
    this.name,
    this.ownerId,
    this.address,
    this.phone,
    this.logoUrl,
    this.createdAt,
    this.employees,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      id: json['id'],
      name: json['name'] ?? '',
      ownerId: json['ownerId'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      logoUrl: json['logoUrl'] ?? '',
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate().toIso8601String()
          : json['createdAt'],
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(), // Konversi ke List<String>
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ownerId': ownerId,
      'address': address,
      'phone': phone,
      'logoUrl': logoUrl,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
      'employees': employees ?? [], // Simpan daftar karyawan
    };
  }

  StoreModel copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? address,
    String? phone,
    String? logoUrl,
    String? createdAt,
    List<dynamic>? employees,
  }) {
    return StoreModel(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      employees: employees ?? this.employees,
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
      'createdAt': createdAt,
      'employees': employees,
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
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      employees: map['employees'] != null
          ? List<dynamic>.from((map['employees'] as List<dynamic>))
          : null,
    );
  }

  @override
  String toString() {
    return 'StoreModel(id: $id, name: $name, ownerId: $ownerId, address: $address, phone: $phone, logoUrl: $logoUrl, createdAt: $createdAt, employees: $employees)';
  }

  @override
  bool operator ==(covariant StoreModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.ownerId == ownerId &&
        other.address == address &&
        other.phone == phone &&
        other.logoUrl == logoUrl &&
        other.createdAt == createdAt &&
        listEquals(other.employees, employees);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        ownerId.hashCode ^
        address.hashCode ^
        phone.hashCode ^
        logoUrl.hashCode ^
        createdAt.hashCode ^
        employees.hashCode;
  }
}
