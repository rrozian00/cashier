import 'package:cashier/app/data/model/order_model.dart';
import 'package:cashier/utils/rupiah_converter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class InputManualController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var tanggalInput = ''.obs;
  var total = ''.obs;

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
    tanggalInput.value = '';
    total.value = '';
    totalC.clear();
  }

  bool _isValid() {
    if (tanggalInput.value.trim().isEmpty || total.value.trim().isEmpty) {
      Get.snackbar("Gagal", "Lengkapi semua data",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  String _convertToIsoString(String date) {
    try {
      final DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
      return parsedDate.toIso8601String();
    } catch (e) {
      return '';
    }
  }

  final storeId = ''.obs;

  Future<void> getId() async {
    final userId = _auth.currentUser!.uid;
    final docUser = await _firestore.collection('users').doc(userId).get();
    storeId.value = docUser.data()?['storeId'];
  }

  Future<void> save() async {
    if (!_isValid()) return;
    await getId();

    final isoDate = _convertToIsoString(tanggalInput.value);

    final data = OrderModel(
      name: "Input Manual",
      payment: "-",
      price: total.value,
      quantity: "1",
      refund: "-",
      createdAt: isoDate,
      total: total.value,
    );

    try {
      // Simpan ke Firestore
      await _firestore
          .collection('stores')
          .doc(storeId.value)
          .collection('orders')
          .add(data.toJson());

      Get.snackbar("Sukses", "Data Berhasil disimpan",
          snackPosition: SnackPosition.BOTTOM);

      clearFields();
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan data: $e",
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
