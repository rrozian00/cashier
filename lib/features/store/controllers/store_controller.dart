import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/core/widgets/my_elevated.dart';
import 'package:cashier/core/widgets/my_text_field.dart';
import 'package:cashier/features/store/models/store_model.dart';

class StoreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final name = "".obs;
  final address = "".obs;
  final phone = "".obs;
  final logoUrl = "".obs;

  var isLoading = false.obs;

  Future<void> addStore() async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      String storeId = _firestore.collection("stores").doc().id; // Buat ID unik
      final createdAt = DateTime.now().toIso8601String();

      final store = StoreModel(
        id: storeId, // Set ID secara eksplisit
        name: name.value,
        ownerId: uid,
        address: address.value,
        phone: phone.value,
        logoUrl: logoUrl.value,
        createdAt: createdAt,
      );

      // Simpan store ke Firestore
      await _firestore.collection("stores").doc(storeId).set(store.toJson());

      // Update storeId pada data user
      await _firestore
          .collection("users")
          .doc(uid)
          .update({"storeId": storeId});
      clearField();
      Get.back();
      getStore();
      Get.snackbar("Sukses", "Store berhasil dibuat!");
    } catch (e) {
      Get.snackbar("Error", "Gagal membuat store: ${e.toString()}");
    }
  }

  void clearField() {
    name.value = '';
    address.value = '';
    phone.value = '';
    logoUrl.value = '';
  }

  void updateStore() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final storeId = userDoc.data()?['storeId'];

      if (storeId == null) return;

      final update = StoreModel(
        id: storeIds.value,
        ownerId: ownerId.value,
        name: name.value,
        address: address.value,
        phone: phone.value,
      );

      await _firestore
          .collection("stores")
          .doc(storeId)
          .update(update.toJson());

      storeName.value = name.value;
      storeAddress.value = address.value;

      getStore();

      Get.snackbar("Sukses", "Data toko berhasil diperbarui!");
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui toko: ${e.toString()}");
    }
  }

  final ownerId = ''.obs;
  final storeIds = ''.obs;
  final storeName = ''.obs;
  final storeAddress = ''.obs;
  final storePhone = ''.obs;

  Future<void> getStore() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    final userId = user.uid;
    ownerId.value = userId;

    final userDoc = await _firestore.collection('users').doc(userId).get();
    final storeIdDoc = userDoc.data()?['storeId'];

    final store = await _firestore.collection("stores").doc(storeIdDoc).get();
    storeIds.value = store.data()?['id'];
    storeName.value = store.data()?['name'];
    storeAddress.value = store.data()?['address'];
    storePhone.value = store.data()?['phone'];
  }

  void editDialog() {
    name.value = storeName.value; // Isi dengan data toko saat ini
    address.value = storeAddress.value;
    phone.value = storePhone.value;

    Get.dialog(AlertDialog(
      title: Text("Edit Toko"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MyTextField(controller: name, label: "Nama Toko"),
          MyTextField(controller: address, label: "Alamat Toko"),
          MyTextField(controller: phone, label: "No HP Toko"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              myElevated(onPress: () => Get.back(), text: "Kembali"),
              myPurpleElevated(
                  onPress: () {
                    updateStore();
                    Get.back();
                  },
                  text: "Simpan"),
            ],
          )
        ],
      ),
    ));
  }

  @override
  void onInit() {
    getStore();
    super.onInit();
  }
}
