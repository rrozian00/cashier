import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/utils/rupiah_converter.dart';
import 'package:cashier/features/home/controllers/home_controller.dart';
import 'package:cashier/features/home/utils/my_card.dart';

class StatisticList extends GetView<HomeController> {
  const StatisticList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async => controller.fetchData(),
        child: ListView(
          children: [
            Obx(() => MyCard(
                  image: "assets/images/income.png",
                  title: "Total Pendapatan Hari Ini",
                  subtitle:
                      rupiahConverterDouble(controller.totalIncomeToday.value),
                  color: green,
                )),
            // SizedBox(height: 16),
            Obx(() => MyCard(
                  image: 'assets/images/expenses.png',
                  title: "Total Pengeluaran Hari Ini",
                  subtitle: rupiahConverterDouble(
                      controller.totalPengeluaranToday.value),
                  color: red,
                )),
          ],
        ),
      ),
    );
  }
}
