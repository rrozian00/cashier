import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/features/home/controllers/home_controller.dart';

class StoreName extends GetView<HomeController> {
  const StoreName({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          AnimatedContainer(
              duration: Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: Icon(
                Icons.store_rounded,
                size: 70,
                color: oldRed,
              )),
          Obx(() => Text(
                controller.storeName.isEmpty
                    ? "Loading..."
                    : "${GetUtils.capitalize(controller.storeName.value)}",
                style: GoogleFonts.pacifico(
                    fontSize: 30, fontWeight: FontWeight.bold, color: oldRed),
              ))
        ],
      ),
    );
  }
}
