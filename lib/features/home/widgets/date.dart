import 'package:cashier/core/theme/colors.dart';
import 'package:cashier/features/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Date extends GetView<HomeController> {
  const Date({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        DateFormat('EEEE   dd-MM-yyyy', 'id_ID').format(DateTime.now()),
        style: GoogleFonts.irishGrover(
          color: purple,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
