// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';

// /// 🔹 **Cek Store Berdasarkan Owner atau Karyawan**
// Future<bool> isOwner() async {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   final userId = auth.currentUser?.uid;
//   if (userId == null) return false;

//   final ownerStore = await firestore
//       .collection('stores')
//       .where('ownerId', isEqualTo: userId)
//       .get();

//   if (ownerStore.docs.isNotEmpty) {
//     String storeId = ownerStore.docs.first.id;
//     return true;
//   } else {
//     // Jika bukan owner, cek apakah user adalah karyawan
//     QuerySnapshot<Map<String, dynamic>> employeeStore = await firestore
//         .collection('stores')
//         .where('employees', arrayContains: userId)
//         .get();

//     if (employeeStore.docs.isNotEmpty) {
//       storeId = employeeStore.docs.first.id;
//       isOwner.value = false;
//     }
//   }

//   if (storeId.isNotEmpty) {
//     debugPrint("Store ditemukan: $storeId (Owner: ${isOwner.value})");
//     fetchMenu();
//   } else {
//     Get.snackbar("Error", "Store tidak ditemukan untuk akun ini!");
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// 🔹 **Cek apakah user adalah Owner atau Karyawan**
Future<bool> getOwner() async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final userId = auth.currentUser?.uid;
  if (userId == null) return false;

  try {
    // Cek apakah user adalah Owner
    final ownerStore = await firestore
        .collection('stores')
        .where('ownerId', isEqualTo: userId)
        .get();

    if (ownerStore.docs.isNotEmpty) {
      return true; // User adalah owner
    }

    // Jika bukan owner, cek apakah user adalah karyawan
    final employeeStore = await firestore
        .collection('stores')
        .where('employees', arrayContains: userId)
        .get();

    if (employeeStore.docs.isNotEmpty) {
      return false; // User adalah karyawan
    }
  } catch (e) {
    print("Error saat mengecek kepemilikan store: $e");
  }

  return false; // Tidak ditemukan dalam store mana pun
}
