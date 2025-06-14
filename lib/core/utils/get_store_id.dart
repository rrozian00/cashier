import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../features/store/models/store_model.dart';
import 'get_user_data.dart';

Future<String> getStoreId() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final storeId = ''.obs;
  // final userId = auth.currentUser?.uid;
  // if (user == null) return "";
  final user = await getUserData();
  if (user == null) return "";

  final ownerStore = await firestore
      .collection('stores')
      .where('ownerId', isEqualTo: user.id)
      .get();

  if (ownerStore.docs.isNotEmpty) {
    storeId.value = ownerStore.docs.first.id;
    return storeId.value;
  } else {
    // Jika bukan owner, cek apakah user adalah karyawan
    QuerySnapshot<Map<String, dynamic>> employeeStore = await firestore
        .collection('stores')
        .where('employees', arrayContains: user.id)
        .get();

    if (employeeStore.docs.isNotEmpty) {
      storeId.value = employeeStore.docs.first.id;
      return storeId.value;
    }
  }
  return '';
}

Future<StoreModel?> getStoreData() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // final userId = auth.currentUser?.uid;
  // if (userId == null) return null;
  final user = await getUserData();
  if (user == null) return null;

  final userData = await getUserData();
  if (userData == null) {
    debugPrint("userData null");
    return null;
  }

  final userRole = userData.role;

  if (userRole == "owner") {
    final ownerStore = await firestore
        .collection('stores')
        .where('ownerId', isEqualTo: user.id)
        .get();

    if (ownerStore.docs.isNotEmpty) {
      debugPrint("ownerStore found: ${ownerStore.docs.first.data()}");
      return StoreModel.fromMap(ownerStore.docs.first.data());
    } else {
      debugPrint("No store found for owner");
    }
  } else {
    final employeeStore = await firestore
        .collection('stores')
        .where('employees', arrayContains: user.id)
        .get();

    if (employeeStore.docs.isNotEmpty) {
      debugPrint("employeeStore found: ${employeeStore.docs.first.data()}");
      return StoreModel.fromMap(employeeStore.docs.first.data());
    } else {
      debugPrint("No store found for employee");
    }
  }

  return null;
}
