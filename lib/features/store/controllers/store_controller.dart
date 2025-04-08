import 'package:cashier/core/utils/get_store_id.dart';
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

  final store = Rxn<StoreModel>(null);
  final name = "".obs;
  final address = "".obs;
  final phone = "".obs;
  final logoUrl = "".obs;

  var isLoading = false.obs;

  Future<void> addStore() async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      String storeId = _firestore.collection("stores").doc().id; // Buat ID unik
      final createdAt = Timestamp.now();

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
      await _firestore.collection("stores").doc(storeId).set(store.toMap());

      // Update storeId pada data user
      await _firestore
          .collection("users")
          .doc(uid)
          .update({"storeId": storeId});

      clearField();
      Get.back();
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
      final storeId = await getStoreId();

      final oldStore = store.value;
      final update = oldStore?.copyWith(
        name: name.value,
        address: address.value,
        phone: phone.value,
      );

      await _firestore
          .collection("stores")
          .doc(storeId)
          .update(update!.toMap());

      store.value = await getStoreData();

      Get.snackbar("Sukses", "Data toko berhasil diperbarui!");
    } catch (e) {
      Get.snackbar("Error", "Gagal memperbarui toko: ${e.toString()}");
    }
  }

  void editDialog() {
    name.value = store.value?.name ?? '';
    address.value = store.value?.address ?? '';
    phone.value = store.value?.phone ?? '';

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

  // Future<void> fetchStore() async {
  //   debugPrint("fetchsttore dpanggil");
  //   store.value = await getStoreData();
  // }

  @override
  void onReady() async {
    super.onReady();
    try {
      store.value = await getStoreData();
      debugPrint("store.value on storeController ${store.value}");
    } catch (e, stack) {
      debugPrint("ERROR getStoreData: $e\n$stack");
    }
  }
}
