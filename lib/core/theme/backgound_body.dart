import 'package:flutter/material.dart';

Widget backgroundBody() {
  return Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          // Colors.purple[100]!,
          // Colors.white,
          // Colors.white,
          // Colors.blue[100]!,
          // Colors.blue[300]!,
          // Colors.purple[200]!,
          Colors.red[200]!,
          Colors.blue[200]!,
          Colors.white,
          Colors.deepPurple[200]!,
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      ),
    ),
  );
}
