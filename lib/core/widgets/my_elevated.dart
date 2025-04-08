import 'package:cashier/core/theme/colors.dart';
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

Widget myPurpleElevated({
  required void Function()? onPress,
  Widget? child,
  String? text,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      decoration: BoxDecoration(
        color: purple,
        border: Border.all(color: purple),
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

Widget myRedElevated({
  required void Function()? onPress,
  Widget? child,
  String? text,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      decoration: BoxDecoration(
        color: red,
        border: Border.all(color: red),
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

Widget myGreenElevated({
  required void Function()? onPress,
  Widget? child,
  String? text,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      decoration: BoxDecoration(
        color: green,
        border: Border.all(color: green),
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

Widget myPurpleIconElevated({
  required void Function()? onPress,
  IconData? icon,
  String? text,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      decoration: BoxDecoration(
        color: purple,
        border: Border.all(color: purple),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Row(
          children: [
            Icon(
              icon ?? Icons.hourglass_empty,
              color: white,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              text ?? '',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
