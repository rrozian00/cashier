import 'package:cashier/core/theme/colors.dart';
import 'package:flutter/material.dart';

Widget homeIndocator() {
  return Center(
      child: Column(
    children: [
      Container(
        width: 150,
        height: 7,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: oldGrey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      SizedBox(
        height: 20,
      )
    ],
  ));
}
