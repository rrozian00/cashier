import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget myElevated({
  required void Function()? onPress,
  Widget? child,
  String? text,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: child ??
            Text(
              text ?? '',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
      ),
    ),
  );
}

Widget myBlueElevated({
  required void Function()? onPress,
  Widget? child,
  String? text,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: child ??
            Text(
              text ?? '',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
      ),
    ),
  );
}
