import 'package:flutter/material.dart';

void showMysnackbar(
  BuildContext context,
  String title,
  String subtitle,
) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Row(
    // mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      Text("$title, "),
      Text(subtitle),
    ],
  )));
}
