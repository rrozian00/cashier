import 'package:flutter/material.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/utils/rupiah_converter.dart';
import 'my_card.dart';

class StatisticList extends StatelessWidget {
  const StatisticList({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          MyCard(
            image: "assets/images/empty.png",
            // title: "Total Pendapatan Hari Ini",
            title: "UNDER MAINTENANCE",
            subtitle: rupiahConverterDouble(12000), //TODO:
            color: green,
          ),
          MyCard(
            image: "assets/images/empty.png",
            title: "UNDER MAINTENANCE",
            // title: "Total Pengeluaran Hari Ini",
            subtitle: rupiahConverterDouble(12000), //TODO:
            color: green,
          ),
          // SizedBox(height: 16),
        ],
      ),
    );
  }
}
