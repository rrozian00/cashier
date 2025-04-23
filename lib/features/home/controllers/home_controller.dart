import 'package:cashier/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/core/utils/get_store_id.dart';
import 'package:cashier/core/utils/get_user_data.dart';
import 'package:cashier/features/store/models/store_model.dart';

class HomeController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final userData = Rxn<UserModel>();
  final storeData = Rxn<StoreModel>();

  final storeId = ''.obs;
  final storeName = ''.obs;
  final storeAddress = ''.obs;

  final totalIncomeToday = 0.0.obs;
  final totalPengeluaranToday = 0.0.obs;

  void getIncomeToday() {
    debugPrint("getincome dipanggil");
    if (storeId.isEmpty) {
      debugPrint("Store ID belum tersedia, menunggu...");
      return;
    }

    try {
      firestore
          .collection('stores')
          .doc(storeId.value)
          .collection('orders')
          .snapshots()
          .listen((snapshot) {
        double total = 0;
        final today = DateTime.now();
        final startOfDay = DateTime(today.year, today.month, today.day);
        final endOfDay = startOfDay.add(const Duration(days: 1));

        for (var doc in snapshot.docs) {
          final data = doc.data();
          final createdAtTimestamp = data['createdAt'] as Timestamp?;

          if (createdAtTimestamp != null) {
            final createdAt = createdAtTimestamp.toDate();
            if (createdAt.isAfter(startOfDay) && createdAt.isBefore(endOfDay)) {
              total += double.tryParse(data['total']?.toString() ?? '') ?? 0;
              debugPrint("total: $total");
            }
          }
        }

        totalIncomeToday.value = total;
      });
    } catch (e) {
      debugPrint("eror income: $e");
    }
  }

  // void getExpenseToday() {
  //   if (storeId.isEmpty) {
  //     debugPrint("Store ID belum tersedia, menunggu...");
  //     return;
  //   }

  //   firestore
  //       .collection('stores')
  //       .doc(storeId.value)
  //       .collection('expenses')
  //       .snapshots()
  //       .listen((snapshot) {
  //     double total = 0;

  //     final today = DateTime.now();
  //     final startOfDay = DateTime(today.year, today.month, today.day);
  //     final endOfDay = startOfDay.add(const Duration(days: 1));

  //     for (var doc in snapshot.docs) {
  //       final data = doc.data();
  //       final createdAtTimestamp = data['createdAt'] as Timestamp?;

  //       if (createdAtTimestamp != null) {
  //         final createdAt = createdAtTimestamp.toDate();

  //         // Cek apakah tanggal transaksi berada di hari ini
  //         if (createdAt.isAfter(startOfDay) && createdAt.isBefore(endOfDay)) {
  //           total += double.tryParse(data['pay']?.toString() ?? '') ?? 0;
  //           debugPrint("Pengeluaran: ${data['pay']}, total: $total");
  //         }
  //       }
  //     }

  //     totalPengeluaranToday.value = total;
  //   });
  // }//TODO

  void listenStoreName() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final user = firebaseAuth.currentUser;

    if (user == null) return;
    final userId = user.uid;

    String storeId = await fetchData();

    final data =
        firestore.collection("store").doc(storeId).snapshots().listen((snap) {
      if (snap.exists) {
        final StoreModel data = StoreModel.fromMap(snap.data()!);
        storeName.value = data.name ?? '';
      }
    });
  }

  Future<String> fetchData() async {
    storeData.value = await getStoreData();

    // storeName.value = storeData.value?.name ?? '';
    storeAddress.value = storeData.value?.address ?? '';
    storeId.value = storeData.value?.id ?? '';

    return storeData.value?.id ?? '';
  }

  @override
  void onReady() async {
    super.onReady();
    userData.value = await getUserData();
    storeData.value = await getStoreData();

    storeName.value = storeData.value?.name ?? '';
    storeAddress.value = storeData.value?.address ?? '';
    storeId.value = storeData.value?.id ?? '';
    debugPrint("Store ID:${storeId.value}");

    // Panggil langsung setelah storeId ada
    if (storeId.isNotEmpty && storeId.value != '') {
      getIncomeToday();
      // getExpenseToday();
    }
  }

  @override
  void onInit() {
    listenStoreName();
    super.onInit();
  }
}
