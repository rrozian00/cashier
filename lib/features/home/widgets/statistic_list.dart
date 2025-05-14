import 'package:flutter/material.dart';

import '../../../core/theme/colors.dart';
import '../../../core/utils/rupiah_converter.dart';
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
            image: "assets/images/income.png",
            title: "Total Pendapatan Hari Ini",
            subtitle: rupiahConverterDouble(12000), //TODO:
            color: green,
          ),
          MyCard(
            image: "assets/images/expenses.png",
            title: "Total Pengeluaran Hari Ini",
            subtitle: rupiahConverterDouble(12000), //TODO:
            color: green,
          ),
          // SizedBox(height: 16),
        ],
      ),
    );
  }
}
