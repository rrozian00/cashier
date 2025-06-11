import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/rupiah_converter.dart';
import 'my_card.dart';

class StatisticList extends StatelessWidget {
  const StatisticList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Terbaru",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              MyCard(
                image: "assets/images/empty.png",
                // title: "Total Pendapatan Hari Ini",
                title: "COMMING SOON",
                subtitle: rupiahConverterDouble(12000), //TODO:
                color: green,
              ),
              MyCard(
                image: "assets/images/empty.png",
                title: "COMMING SOON",
                // title: "Total Pengeluaran Hari Ini",
                subtitle: rupiahConverterDouble(12000), //TODO:
                color: green,
              ),
              // SizedBox(height: 16),
            ],
          ),
        ],
      ),
    );
  }
}
