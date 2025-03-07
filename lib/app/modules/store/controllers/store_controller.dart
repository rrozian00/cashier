import 'package:cashier/app/data/model/store_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StoreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController logoUrl = TextEditingController();

  var isLoading = false.obs;

  Future<void> addStore() async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      String storeId = _firestore.collection("stores").doc().id; // Buat ID unik
      final createdAt = DateTime.now().toIso8601String();

      final store = StoreModel(
        id: storeId, // Set ID secara eksplisit
        name: name.text,
        ownerId: uid,
        address: address.text,
        phone: phone.text,
        logoUrl: logoUrl.text,
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
    name.clear();
    address.clear();
    phone.clear();
    logoUrl.clear();
  }

  Future<void> updateStore() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) return;

      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final storeId = userDoc.data()?['storeId'];

      if (storeId == null) return;

      final update = StoreModel(
        id: storeIds.value,
        ownerId: ownerId.value,
        name: name.text,
        address: address.text,
        phone: phone.text,
      );

      await _firestore
          .collection("stores")
          .doc(storeId)
          .update(update.toJson());

      storeName.value = name.text;
      storeAddress.value = address.text;

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
    name.text = storeName.value; // Isi dengan data toko saat ini
    address.text = storeAddress.value;
    phone.text = storePhone.value;

    Get.defaultDialog(
      title: "Edit Toko",
      content: Column(
        children: [
          TextField(
            controller: name,
            decoration: InputDecoration(labelText: "Nama Toko"),
          ),
          TextField(
            controller: address,
            decoration: InputDecoration(labelText: "Alamat"),
          ),
          TextField(
            controller: phone,
            decoration: InputDecoration(labelText: "Telepon"),
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      onConfirm: () {
        updateStore();
        Get.back();
      },
    );
  }

  @override
  void onInit() {
    getStore();
    super.onInit();
  }
}
