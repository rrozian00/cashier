import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/utils/get_store_id.dart';

import '../../../core/widgets/my_text_field.dart';
import '../models/store_model.dart';

class StoreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final store = Rxn<StoreModel>(null);
  final name = TextEditingController();
  final address = TextEditingController();
  final phone = TextEditingController();
  final logoUrl = TextEditingController();

  var isLoading = false.obs;

  Future<void> addStore() async {
    try {
      String uid = _firebaseAuth.currentUser!.uid;
      String storeId = _firestore.collection("stores").doc().id; // Buat ID unik
      final createdAt = Timestamp.now();

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
    name.clear();
    address.clear();
    phone.clear();
    logoUrl.clear();
  }

  void updateStore() async {
    try {
      final storeId = await getStoreId();

      final oldStore = store.value;
      final update = oldStore?.copyWith(
        name: name.text,
        address: address.text,
        phone: phone.text,
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

  void editDialog(BuildContext context) {
    name.text = store.value?.name ?? '';
    address.text = store.value?.address ?? '';
    phone.text = store.value?.phone ?? '';

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Ubah Toko",
                  style: GoogleFonts.poppins(fontSize: 18),
                ),
                SizedBox(height: 15),
                MyTextField(controller: name, label: "Nama Toko"),
                MyTextField(controller: address, label: "Alamat Toko"),
                MyTextField(controller: phone, label: "No HP Toko"),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      // width: 150,
                      onPressed: () => Get.back(),
                      // text: "Kembali",
                      child: Text("Kembali"),
                    ),
                    ElevatedButton(
                      child: Text("Simpan"),
                      // width: 150,
                      onPressed: () {
                        updateStore();
                        Get.back();
                      },
                      // text: "Simpan",
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> fetchStore() async {
  //   debugPrint("fetchsttore dpanggil");
  //   store.value = await getStoreData();
  // }

  @override
  void onReady() async {
    super.onReady();
    store.value = await getStoreData();
  }
}
