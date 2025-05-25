import '../repositories/order_repository.dart';

import '../../user/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/get_store_id.dart';
import '../models/order_model.dart';

class HistoryOrderController extends GetxController {
  final orderRepo = OrderRepository();

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
    );

    if (picked != null && picked != selectedDateRange.value) {
      selectedDateRange.value = picked;
      formattedDateRange.value =
          '${DateFormat('dd/MM/yyyy').format(picked.start)} - ${DateFormat('dd/MM/yyyy').format(picked.end)}';

      final startTimestamp = Timestamp.fromDate(selectedDateRange.value!.start);
      final endTimestamp = Timestamp.fromDate(
          selectedDateRange.value!.end.add(Duration(days: 1)));
      await fetchData(startTimestamp, endTimestamp);
      updateCalculations();
    }
  }

  Future<void> fetchData(
    Timestamp start,
    Timestamp end,
  ) async {
    isLoading.value = true;
    final result = await orderRepo.getHistoryOrders(start, end);
    result.fold(
      (err) {
        Get.snackbar("Error", err.message);
        isLoading.value = false;
      },
      (datas) {
        orderList.value = datas;
        isLoading.value = false;
      },
    );
  }

  void updateCalculations() {
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
    orderList.value = [];
  }

  @override
  void onReady() async {
    super.onReady();
    storeId.value = await getStoreId();
  }
}
