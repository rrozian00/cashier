// controllers/history_order_controller.dart
import 'package:cashier/app/data/model/expense_model.dart';
import 'package:cashier/app/data/model/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HistoryOrderController extends GetxController {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var totalPenjualanHariIni = 0.0.obs;
  var totalProfitHariIni = 0.0.obs;
  var storeId = ''.obs;

  var orderList = <OrderModel>[].obs;
  var filteredOrderList = <OrderModel>[].obs;
  var expenseList = <ExpenseModel>[].obs;
  var filteredExpenseList = <ExpenseModel>[].obs;

  var filteredTotalPenjualan = 0.0.obs;
  var filteredTotalSalary = 0.0.obs;
  var filteredTotalExpense = 0.0.obs;
  var filteredTotalProfit = 0.0.obs;

  var selectedDateRange = Rx<DateTimeRange?>(null);
  var formattedDateRange = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchStoreId();
  }

  Future<void> fetchStoreId() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return;
    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final fetchedStoreId = userDoc.data()?['storeId'];

    if (fetchedStoreId != null) {
      storeId.value = fetchedStoreId;
      fetchOrder();
      fetchExpense();
    }
  }

  void fetchOrder() {
    if (storeId.isEmpty) return;
    _firestore
        .collection("stores")
        .doc(storeId.value)
        .collection("orders")
        .snapshots()
        .listen((snapshot) {
      orderList.assignAll(
          snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList());
      applyFilters();
    });
  }

  void fetchExpense() {
    if (storeId.isEmpty) return;
    _firestore
        .collection("stores")
        .doc(storeId.value)
        .collection("expenses")
        .snapshots()
        .listen((snapshot) {
      expenseList.assignAll(snapshot.docs
          .map((doc) => ExpenseModel.fromJson(doc.data()))
          .toList());
      applyFilters();
    });
  }

  void applyFilters() {
    if (selectedDateRange.value == null) {
      filteredOrderList.assignAll(orderList);
      filteredExpenseList.assignAll(expenseList);
    } else {
      filterDataByDateRange(selectedDateRange.value!);
    }
    updateCalculations();
  }

  void filterDataByDateRange(DateTimeRange selectedRange) {
    final startDate = selectedRange.start;
    final endDate = selectedRange.end;

    filteredOrderList.assignAll(orderList.where((transaksi) {
      try {
        final transaksiDate = DateTime.parse(transaksi.createdAt ?? "");
        return transaksiDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            transaksiDate.isBefore(endDate.add(Duration(days: 1)));
      } catch (e) {
        return false;
      }
    }).toList());

    filteredExpenseList.assignAll(expenseList.where((expense) {
      try {
        final expenseDate = DateFormat('dd-MM-yyyy').parse(expense.date ?? '');
        return expenseDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            expenseDate.isBefore(endDate.add(Duration(days: 1)));
      } catch (e) {
        return false;
      }
    }).toList());
  }

  void updateCalculations() {
    filteredTotalPenjualan.value = filteredOrderList.fold(
      0,
      (sum, transaksi) => sum + double.tryParse(transaksi.total ?? '0')!,
    );

//Perhitungan gaji
    filteredTotalSalary.value = filteredOrderList.fold(0.0,
        (sum, tran) => sum + (double.tryParse(tran.total ?? '0') ?? 0) * 0.27);

    filteredTotalExpense.value = filteredExpenseList.fold(
      0.0,
      (sum, expense) => sum + (double.tryParse(expense.pay ?? '0') ?? 0),
    );

    filteredTotalProfit.value = filteredTotalPenjualan.value -
        filteredTotalSalary.value -
        filteredTotalExpense.value;
  }

  void resetDateRangeAndData() {
    selectedDateRange.value = null;
    formattedDateRange.value = null;
    applyFilters();
  }
}
