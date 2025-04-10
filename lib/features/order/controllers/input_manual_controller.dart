import 'package:cashier/features/order/models/order_model.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InputManualController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var inputDate = ''.obs;
  var total = ''.obs;
  final storeId = ''.obs;

  final TextEditingController totalC = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    // Sinkronkan nilai `total` dengan `totalC`
    total.listen((value) {
      int parsedValue = int.tryParse(value) ?? 0;
      totalC.text = rupiahConverter(parsedValue);
    });
  }

  void clearFields() {
    inputDate.value = '';
    total.value = '';
    totalC.clear();
  }

  bool _isValid() {
    if (inputDate.value.trim().isEmpty || total.value.trim().isEmpty) {
      Get.snackbar("Gagal", "Lengkapi semua data",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  Future<void> getId() async {
    final userId = _auth.currentUser!.uid;
    final docUser = await _firestore.collection('users').doc(userId).get();
    storeId.value = docUser.data()?['storeId'];
  }

  Future<void> save() async {
    if (!_isValid()) return;
    await getId();
    final dateFormat = DateFormat("dd-MM-yyyy");
    final inputDateParsed = dateFormat.parse(inputDate.value);

    final createdAt = Timestamp.fromDate(inputDateParsed);
    try {
      final docRef = _firestore
          .collection('stores')
          .doc(storeId.value)
          .collection('orders')
          .doc();

      final data = OrderModel(
        id: docRef.id,
        total: total.value,
        createdAt: createdAt,
      );
      await docRef.set(data.toMap());

      Get.snackbar("Sukses", "Data Berhasil disimpan",
          snackPosition: SnackPosition.BOTTOM);

      clearFields();
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan data: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
