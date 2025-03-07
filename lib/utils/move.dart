import 'package:cashier/app/data/database/database_instance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Fungsi untuk menampilkan loading dialog
void showLoadingDialog() {
  Get.dialog(
    PopScope(
      canPop: false,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Memindahkan data, harap tunggu..."),
          ],
        ),
      ),
    ),
    barrierDismissible: false, // Dialog tidak bisa ditutup manual
  );
}

// Fungsi untuk memindahkan data ke Firestore dengan loading dialog
Future<void> moveExpenseToFirebase() async {
  showLoadingDialog();

  try {
    final DatabaseInstance db = DatabaseInstance();

    // Ambil data yang BELUM dipindahkan (isSynced = 0)
    List<Map<String, dynamic>> expenses =
        await db.read('expense', 'createdAt DESC', 'isSynced = 0');

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    for (var expense in expenses) {
      await firestore.collection('expenses').add({
        'date': expense['date'],
        'pay': expense['pay'],
        'createdAt': expense['createdAt'],
      });

      // Update status isSynced di SQLite agar tidak dipindahkan lagi
      await db.update('expense', expense['id'], {'isSynced': 1});
    }

    Get.back();
    Get.snackbar("Sukses", "Data expense berhasil dipindahkan!");
  } catch (e) {
    Get.back();
    Get.snackbar("Error", "Gagal memindahkan data: $e");
  }
}

Future<void> moveMenuToFirestore() async {
  showLoadingDialog();
  try {
    final DatabaseInstance db = DatabaseInstance();
    List<Map<String, dynamic>> menus =
        await db.read('menu', 'createdAt DESC', 'isSynced = 0');

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    for (var menu in menus) {
      await firestore.collection('menus').add({
        'name': menu['name'],
        'price': menu['price'],
        'image': menu['image'],
        'createdAt': menu['createdAt'],
      });
      await db.update('menu', menu['id'], {'isSynced': 1});
    }

    Get.back();
    Get.snackbar("Sukses", "Data menu berhasil dipindahkan!");
  } catch (e) {
    Get.back();
    Get.snackbar("Error", "Gagal memindahkan menu: $e");
  }
}

Future<void> moveOrderToFirestore() async {
  showLoadingDialog();
  try {
    final DatabaseInstance db = DatabaseInstance();
    List<Map<String, dynamic>> orders =
        await db.read('orders', 'createdAt DESC', 'isSynced=0');

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    for (var order in orders) {
      await firestore.collection('orders').add({
        'name': order['name'],
        'quantity': order['quantity'],
        'price': order['price'],
        'image': order['image'],
        'total': order['total'],
        'payment': order['payment'],
        'refund': order['refund'],
        'createdAt': order['createdAt'],
      });
      await db.update('orders', order['id'], {'isSynced': 1});
    }

    Get.back();
    Get.snackbar("Sukses", "Data order berhasil dipindahkan!");
  } catch (e) {
    Get.back();
    Get.snackbar("Error", "Gagal memindahkan order: $e");
  }
}
