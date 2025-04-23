import 'package:cashier/features/expense/models/expense_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ExpenseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<ExpenseModel>> getExpense() async {
    try {
      final userId = _auth.currentUser!.uid;
      final doc = await _firestore.collection('users').doc(userId).get();
      final storeId = doc.data()?['storeId'];

      final snapshot = await _firestore
          .collection('stores')
          .doc(storeId)
          .collection('expenses')
          .get();

      final data =
          snapshot.docs.map((e) => ExpenseModel.fromMap(e.data())).toList();
      return data;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> insertExpense({
    required String date,
    required String pay,
  }) async {
    final userId = _auth.currentUser!.uid;

    final doc = await _firestore.collection('users').doc(userId).get();
    final storeId = doc.data()?['storeId'];

    if (storeId == null) {
      Get.snackbar("Gagal", "Tidak ada toko");
      return;
    }

    final createdAt = Timestamp.now();
    final data = ExpenseModel(
      date: date,
      pay: pay,
      createdAt: createdAt,
    );

    try {
      await _firestore
          .collection('stores')
          .doc(storeId)
          .collection('expenses')
          .add(data.toMap());
    } catch (e) {
      throw Exception("Gagal menyimpan data: $e");
    }
  }
}
