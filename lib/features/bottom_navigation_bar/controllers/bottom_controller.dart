import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var selectedIndex = 0.obs;
  final role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getUserRole();
  }

  Future<void> getUserRole() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      DocumentSnapshot userData =
          await _firestore.collection("users").doc(currentUser.uid).get();

      if (userData.exists) {
        role.value = userData['role'];
        debugPrint("User Role:$role");
      } else {
        Get.snackbar("Error", "Akun tidak ditemukan!");
        await _firebaseAuth.signOut();
      }
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
