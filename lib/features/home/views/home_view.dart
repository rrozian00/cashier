import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // Tanggal Sekarang
                // const Date(),

                // //Tag Line
                // const TagLineWidget(),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Animasi Logo Toko
                Text(controller.datadummy.value),

                // const StoreName(),

                // // Statistik Keuangan
                // const StatisticList(),
              ],
            )
          ],
        ),
      ),
    );

    // BlocListener<AuthBloc, AuthState>(
    //   listener: (context, state) {
    //     if (state is UnauthenticatedState) {
    //       Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(
    //             builder: (context) => LoginView(),
    //           ));
    //     }
    //   },
    //   child: Scaffold(
    //     backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    //     body: SafeArea(
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Column(
    //             children: [
    //               // Tanggal Sekarang
    //               const Date(),

    //               //Tag Line
    //               const TagLineWidget(),
    //             ],
    //           ),
    //           Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               // Animasi Logo Toko
    //               const StoreName(),

    //               // Statistik Keuangan
    //               const StatisticList(),
    //             ],
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
