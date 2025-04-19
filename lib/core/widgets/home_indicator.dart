import 'package:cashier/core/theme/colors.dart';
import 'package:flutter/material.dart';

Widget homeIndicator() {
  return Center(
      child: Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Container(
        width: 140,
        height: 5,
        decoration: BoxDecoration(
          color: oldGrey,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      SizedBox(
        height: 25,
      )
    ],
  ));
}
