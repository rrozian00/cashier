import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:cashier/core/widgets/my_appbar.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        icon: Icons.store,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Obx(() => SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    "Hai, ${controller.userData.value?.name}",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.deepPurple,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )),
          ),
        ],
        // leading: IconButton(
        //   onPressed: () => ,
        //   icon: Icon(Icons.refresh, color: Colors.deepPurple),
        // ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Animasi Logo Toko
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      color: Colors.deepPurple,
                      'assets/icons/icon.png',
                      height: 70,
                    ),
                  ),
                  Obx(() => Text(
                        controller.storeName.isEmpty
                            ? "Loading..."
                            : controller.storeName.value,
                        style: GoogleFonts.pacifico(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
            SizedBox(height: 20),

            // Tanggal Sekarang
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                DateFormat('EEEE, dd-MM-yyyy', 'id_ID').format(DateTime.now()),
                style: GoogleFonts.poppins(
                  color: Colors.blue[900],
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            // Statistik Keuangan
            Expanded(
              child: RefreshIndicator(
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                onRefresh: () async => controller.fetchData(),
                child: ListView(
                  children: [
                    // Obx(() => MyCard(
                    //       image: "assets/images/income.png",
                    //       title: "Total Pendapatan Hari Ini",
                    //       subtitle: rupiahConverterDouble(
                    //           controller.totalIncomeToday.value),
                    //       color: Colors.green[900],
                    //     )),
                    // // SizedBox(height: 16),
                    // Obx(() => MyCard(
                    //       image: 'assets/images/expenses.png',
                    //       title: "Total Pengeluaran Hari Ini",
                    //       subtitle: rupiahConverterDouble(
                    //           controller.totalPengeluaranToday.value),
                    //       color: Colors.red[700],
                    //     )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget Custom untuk Menampilkan Data dalam Card yang Elegan
class MyCard extends StatelessWidget {
  const MyCard({
    this.image,
    this.title,
    this.subtitle,
    this.color,
    super.key,
  });

  final String? title;
  final String? image;
  final String? subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      // elevation: 5,
      decoration: BoxDecoration(
          // border: Border.all(),
          borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Pendapatan atau Pengeluaran
            CircleAvatar(
              backgroundColor: color?.withAlpha(70),
              radius: 25,
              child: Image.asset(
                image ?? 'assets/icons/icon.png',
                height: 35,
                width: 35,
              ),
            ),
            SizedBox(width: 20),

            // Teks Deskripsi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '-',
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle ?? '-',
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
