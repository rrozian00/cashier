import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/features/user/blocs/auth/auth_bloc.dart';
import 'package:cashier/features/home/widgets/date.dart';
import 'package:cashier/features/home/widgets/statistic_list.dart';
import 'package:cashier/features/home/widgets/store_name.dart';
import 'package:cashier/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnauthenticatedState) {
          Get.offAllNamed(Routes.login);
        }
      },
      child: Scaffold(
        backgroundColor: softGrey,
        // appBar: MyAppBar(
        //   actions: [
        //     Padding(
        //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
        //       child: Obx(() => SingleChildScrollView(
        //             scrollDirection: Axis.horizontal,
        //             child: Text(
        //               "Hai, ${controller.userData.value?.name}",
        //               style: GoogleFonts.poppins(
        //                 fontSize: 16,
        //                 color: purple,
        //                 fontWeight: FontWeight.bold,
        //               ),
        //             ),
        //           )),
        //     ),
        //   ],
        // ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "for simple life, use",
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          color: brown,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Cashier !!",
                        style: GoogleFonts.lobster(
                          color: black,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Date(),
                    ],
                  ),
                  // SizedBox(height: 20),

                  // // Animasi Logo Toko
                  StoreName(),
                  SizedBox(height: 20),

                  // Tanggal Sekarang

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Rekapan untuk anda",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Statistik Keuangan
                  StatisticList(),

                  SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Rekapan untuk anda",
                      style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Statistik Keuangan
                  StatisticList(),
                ],
              ),
            ),
          ),
        ),
        // floatingActionButton: ElevatedButton(onPressed: () {
        //   context.read<AuthBloc>().add(AuthLogoutEvent());
        // }, child: BlocBuilder<AuthBloc, AuthState>(
        //   builder: (context, state) {
        //     if (state is UnauthenticatedState) {
        //       return CircularProgressIndicator();
        //     } else {
        //       return Text("Keluar");
        //     }
        //   },
        // )),
      ),
    );
  }
}
