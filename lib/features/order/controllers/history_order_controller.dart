import 'package:cashier/features/user/controllers/employee_controller.dart';
import 'package:cashier/features/user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:cashier/core/utils/get_store_id.dart';
import 'package:cashier/features/order/models/order_model.dart';

class HistoryOrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final employeeController = Get.find<EmployeeController>();

  final listEmployee = <UserModel>[].obs;
  var storeId = ''.obs;

  final isLoading = false.obs;

  var totalPenjualanHariIni = 0.0.obs;
  var totalProfitHariIni = 0.0.obs;

  var orderList = <OrderModel>[].obs;

  var totalPenjualan = 0.0.obs;
  var totalSalary = 0.0.obs;
  var totalExpense = 0.0.obs;
  var totalProfit = 0.0.obs;

  var selectedDateRange = Rx<DateTimeRange?>(null);
  var formattedDateRange = Rx<String?>(null);

  // DateRangePicker
  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: selectedDateRange.value,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDateRange.value) {
      selectedDateRange.value = picked;
      formattedDateRange.value =
          '${DateFormat('dd/MM/yyyy').format(picked.start)} - ${DateFormat('dd/MM/yyyy').format(picked.end)}';

      await fetchOrder();
      updateCalculations();
    }
  }

  Future<void> fetchOrder() async {
    if (storeId.isEmpty) return;
    debugPrint("isi storeId ${storeId.value}");

    try {
      isLoading.value = true;
      final start = selectedDateRange.value!.start;
      debugPrint("isi start ${start.toString()}");
      debugPrint("ts:${Timestamp.fromDate(start)}");

      final end = selectedDateRange.value!.end;
      final endPlusOne = end.add(const Duration(days: 1));

      final querySnap = await _firestore
          .collection("stores")
          .doc(storeId.value)
          .collection("orders")
          .where("createdAt", isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where("createdAt",
              isLessThanOrEqualTo: Timestamp.fromDate(endPlusOne))
          .get();
      orderList.value =
          querySnap.docs.map((e) => OrderModel.fromMap(e.data())).toList();
      debugPrint("isi orderlist ${orderList.length}");
    } catch (e) {
      debugPrint("eror fetch order: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updateCalculations() {
    listEmployee.value = employeeController.listEmployee;

    totalPenjualan.value = orderList.fold(
      0,
      (sum1, transaksi) => sum1 + double.tryParse(transaksi.total ?? '0')!,
    );

    totalSalary.value = listEmployee.fold<double>(
      0.0,
      (sum1, e) =>
          sum1 +
          ((totalPenjualan.value * (int.tryParse(e.salary ?? '0') ?? 0)) / 100),
    );

    totalProfit.value =
        totalPenjualan.value - totalSalary.value - totalExpense.value;
  }

  void resetDateRangeAndData() {
    selectedDateRange.value = null;
    formattedDateRange.value = null;
  }

  @override
  void onReady() async {
    super.onReady();
    storeId.value = await getStoreId();
  }
}
