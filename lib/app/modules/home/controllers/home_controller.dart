import 'package:cashier/app/modules/expense/controllers/expense_controller.dart';
import 'package:cashier/app/modules/history_order/controllers/history_order_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final HistoryOrderController riwayatController = Get.find();
  final ExpenseController expenseController = Get.find();
  var totalIncomeToday = 0.0.obs;
  var totalPengeluaranToday = 0.0.obs;
  final storeNameFinal = ''.obs;
  final storeIdFinal = ''.obs;
  final storeAddressFinal = ''.obs;
  final userNameFinal = ''.obs;
  final userRole = ''.obs;
  final userId = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    await getStoreId();
    await getStoreName();
    getIncomeToday();
    getPengeluaranToday();
  }

  // Future<void> getStoreId() async {
  //   final user = _auth.currentUser;
  //   if (user == null) return;

  //    userId.value = user.uid;
  //   final doc = await _firestore.collection('users').doc(userId.value).get();
  //   userRole.value = doc.data()?['role'];
  //   // if (userRole == "karyawan") return;
  //   final userName = doc.data()?['name'];
  //   userNameFinal.value = userName;
  //   debugPrint(userName);

  //   final storeId = doc.data()?['storeId'];
  //   storeIdFinal.value = storeId;
  // }
  Future<void> getStoreId() async {
    final user = _auth.currentUser;
    if (user == null) return;

    userId.value = user.uid;

    // Ambil data user
    final userDoc =
        await _firestore.collection('users').doc(userId.value).get();
    userRole.value = userDoc.data()?['role'] ?? '';

    if (userRole.value == "owner") {
      // Jika Owner, langsung ambil storeId dari user
      storeIdFinal.value = userDoc.data()?['storeId'] ?? '';
    } else if (userRole.value == "karyawan") {
      // Jika Karyawan, cari store yang memiliki userId ini dalam array employees
      final storesQuery = await _firestore
          .collection('stores')
          .where('employees', arrayContains: userId.value)
          .get();

      if (storesQuery.docs.isNotEmpty) {
        storeIdFinal.value = storesQuery.docs.first.id;
      }
    }

    if (storeIdFinal.value.isEmpty) {
      debugPrint("Store ID tidak ditemukan untuk user ${userId.value}");
    } else {
      debugPrint(
          "User ${userId.value} memiliki Store ID: ${storeIdFinal.value}");
    }
  }

  // Future<void> getStoreName() async {
  //   if (userRole.value == "owner") {
  //     final storeDoc =
  //         await _firestore.collection('stores').doc(storeIdFinal.value).get();
  //     final storeName = storeDoc.data()?['name'];
  //     // final storeAddress = storeDoc.data()?['address'];
  //     // debugPrint("address: $storeAddress");
  //     storeNameFinal.value = storeName;
  //     // storeAddressFinal.value = storeAddress;
  //   } else {
  //     final storeDoc=await _firestore.collection('stores').doc().get();
  //     final storeName=storeDoc.where(userId.value==doc.id)
  //   }
  // }

  Future<void> getStoreName() async {
    if (storeIdFinal.value.isEmpty) {
      debugPrint("Store ID belum tersedia, menunggu...");
      return;
    }

    final storeDoc =
        await _firestore.collection('stores').doc(storeIdFinal.value).get();

    if (storeDoc.exists) {
      storeNameFinal.value =
          storeDoc.data()?['name'] ?? 'Nama Toko Tidak Ditemukan';
      storeAddressFinal.value =
          storeDoc.data()?['address'] ?? 'Alamat Tidak Diketahui';
      debugPrint("Nama Toko: ${storeNameFinal.value}");
    } else {
      debugPrint("Store dengan ID ${storeIdFinal.value} tidak ditemukan!");
    }
  }

  void getIncomeToday() {
    if (storeIdFinal.isEmpty) {
      debugPrint("Store ID belum tersedia, menunggu...");
      return;
    }
    _firestore
        .collection('stores')
        .doc(storeIdFinal.value)
        .collection('orders')
        .snapshots()
        .listen((snapshot) {
      double total = 0;
      final today = DateTime.now();
      final todayString = DateFormat('dd-MM-yyyy').format(today);

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final createdAtString = data['createdAt'] as String?;

        if (createdAtString != null) {
          final createdAt = DateTime.parse(createdAtString);
          final orderDate = DateFormat('dd-MM-yyyy').format(createdAt);

          if (orderDate == todayString) {
            total += double.tryParse(data['total']?.toString() ?? '') ?? 0;
          }
        }
      }
      totalIncomeToday.value = total;
    });
  }

  void getPengeluaranToday() {
    if (storeIdFinal.isEmpty) {
      debugPrint("Store ID belum tersedia, menunggu...");
      return;
    }

    _firestore
        .collection('stores')
        .doc(storeIdFinal.value)
        .collection('expenses') // Mengambil data dari koleksi pengeluaran
        .snapshots()
        .listen((snapshot) {
      double total = 0;
      final today = DateTime.now();
      final todayString = DateFormat('dd-MM-yyyy').format(today);

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final createdAtString = data['createdAt'] as String?;

        if (createdAtString != null) {
          final createdAt = DateTime.parse(createdAtString);
          final expenseDate = DateFormat('dd-MM-yyyy').format(createdAt);
          debugPrint(todayString);

          if (expenseDate == todayString) {
            total += double.tryParse(data['pay']?.toString() ?? '') ?? 0;
          }
        }
      }
      totalPengeluaranToday.value = total;
    });
  }
}
