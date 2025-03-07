import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? id;
  String? date;
  String? pay;
  String? createdAt;

  ExpenseModel({
    this.id,
    this.date,
    this.pay,
    this.createdAt,
  });

  // Konversi dari JSON ke Model
  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      id: json['id'], // ID bisa null kalau baru ditambahkan
      date: json['date'],
      pay: json['pay'],
      createdAt: json['createdAt'] is Timestamp
          ? json['createdAt'] as Timestamp
          : json['createdAt'],
    );
  }

  // Konversi dari Model ke JSON (untuk Firestore)
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'pay': pay,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }

  // copyWith untuk update data tanpa buat objek baru
  ExpenseModel copyWith({
    String? id,
    String? date,
    String? pay,
    String? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      date: date ?? this.date,
      pay: pay ?? this.pay,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
