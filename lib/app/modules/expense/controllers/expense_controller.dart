import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cashier/app/data/model/expense_model.dart';
import 'package:cashier/utils/my_date_picker.dart';
import 'package:cashier/utils/rupiah_converter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExpenseController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var listExpense = <ExpenseModel>[].obs;
  var totalPengeluaranHariIni = 0.0.obs;
  var date = ''.obs;
  var pay = ''.obs;

  final dateC = TextEditingController();
  final payC = TextEditingController();

  late Worker _expenseListener;
  late Worker _totalListener;

  @override
  void onInit() {
    super.onInit();
    fetchExpense();
    total();

    _expenseListener = ever(date, (_) => dateC.text = date.value);
    _totalListener = ever(pay, (_) {
      int parsed = int.tryParse(pay.value) ?? 0;
      payC.text = rupiahConverter(parsed);
    });
  }

  @override
  void onClose() {
    _expenseListener.dispose();
    _totalListener.dispose();
    dateC.dispose();
    payC.dispose();
    super.onClose();
  }

  bool isValid() {
    if (date.value.isEmpty || pay.value.isEmpty) {
      Get.snackbar("Peringatan", "Lengkapi Kolom");
      return false;
    }
    return true;
  }

  void insertExpense() async {
    final userId = _auth.currentUser!.uid;

    final doc = await _firestore.collection('users').doc(userId).get();
    final storeId = doc.data()?['storeId'];

    if (storeId == null) {
      Get.snackbar("Gagal", "Tidak ada toko");
      return;
    }

    if (!isValid()) return;

    final createdAt = DateTime.now().toIso8601String();
    final data = ExpenseModel(
      date: date.value,
      pay: pay.value,
      createdAt: createdAt,
    );

    try {
      await _firestore
          .collection('stores')
          .doc(storeId)
          .collection('expenses')
          .add(data.toJson());

      Get.back();
      fetchExpense();
      Get.snackbar("Sukses", "Berhasil Tambah Pengeluaran");
      clearField();
    } catch (e) {
      Get.snackbar("Error", "Gagal menyimpan data: $e");
    }
  }

  Future<void> fetchExpense() async {
    final userId = _auth.currentUser!.uid;
    final doc = await _firestore.collection('users').doc(userId).get();
    final storeId = doc.data()?['storeId'];

    final snapshot = await _firestore
        .collection('stores')
        .doc(storeId)
        .collection('expenses')
        .get();

    listExpense.assignAll(snapshot.docs.map((doc) {
      return ExpenseModel.fromJson(doc.data());
    }).toList());
  }

  void total() {
    totalPengeluaranHariIni.value = listExpense.fold(
      0,
      (sum, expense) => sum + (double.tryParse(expense.pay ?? "0") ?? 0.0),
    );
  }

  void clearField() {
    date.value = '';
    pay.value = '';
  }

  void addDialog() {
    Get.defaultDialog(
      title: "Tambah Belanja",
      content: Column(
        children: [
          MyDatePicker(
            labelText: "Tanggal",
            controller: dateC,
            onDateSelected: (value) => date.value = value,
          ),
          SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            controller: payC,
            onChanged: (value) {
              String rawValue = value.replaceAll(RegExp(r'[^\d]'), '');
              int parseValue = int.tryParse(rawValue) ?? 0;

              pay.value = parseValue.toString();
              payC.text = rupiahConverter(parseValue);
              payC.selection =
                  TextSelection.collapsed(offset: payC.text.length);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              label: Text("Total Belanja"),
            ),
          ),
        ],
      ),
      onConfirm: insertExpense,
      textConfirm: "Simpan",
      onCancel: clearField,
      textCancel: "Batal",
    );
  }
}
