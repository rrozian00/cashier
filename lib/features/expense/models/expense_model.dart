// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? id;
  String? date;
  String? pay;
  Timestamp? createdAt;

  ExpenseModel({
    this.id,
    this.date,
    this.pay,
    this.createdAt,
  });

  ExpenseModel copyWith({
    String? id,
    String? date,
    String? pay,
    Timestamp? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      date: date ?? this.date,
      pay: pay ?? this.pay,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date,
      'pay': pay,
      'createdAt': createdAt,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] != null ? map['id'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      pay: map['pay'] != null ? map['pay'] as String : null,
      createdAt:
          map['createdAt'] != null ? map['createdAt'] as Timestamp : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpenseModel.fromJson(String source) =>
      ExpenseModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ExpenseModel(id: $id, date: $date, pay: $pay, createdAt: $createdAt)';
  }

  @override
  bool operator ==(covariant ExpenseModel other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.date == date &&
        other.pay == pay &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^ date.hashCode ^ pay.hashCode ^ createdAt.hashCode;
  }
}
