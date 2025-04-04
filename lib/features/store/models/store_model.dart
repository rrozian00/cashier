import 'package:cloud_firestore/cloud_firestore.dart';

class StoreModel {
  String? id;
  String? name;
  String? ownerId;
  String? address;
  String? phone;
  String? logoUrl;
  String? createdAt;
  List<String>? employees; // Menyimpan daftar karyawan

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
}
