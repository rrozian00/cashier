import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/core/widgets/my_appbar.dart';
import 'package:cashier/features/home/widgets/date.dart';
import 'package:cashier/features/home/widgets/statistic_list.dart';
import 'package:cashier/features/home/widgets/store_name.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softGrey,
      appBar: MyAppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "Hai, ${controller.userData.value?.name}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: purple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),

            // Animasi Logo Toko
            StoreName(),
            SizedBox(height: 20),

            // Tanggal Sekarang
            Date(),
            SizedBox(height: 30),

            // Statistik Keuangan
            StatisticList(),
          ],
        ),
      ),
    );
  }
}
