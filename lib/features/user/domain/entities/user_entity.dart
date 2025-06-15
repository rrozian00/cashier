import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity {
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
}
