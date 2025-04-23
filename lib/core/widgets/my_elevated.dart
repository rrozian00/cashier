import 'package:cashier/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget myElevated({
  double? width,
  double? height,
  required void Function()? onPress,
  Widget? child,
  String? text,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      width: width,
      height: height ?? 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Center(
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
    ),
  );
}

Widget myPurpleElevated({
  required void Function()? onPress,
  Widget? child,
  String? text,
  double? width,
  double? height,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      width: width,
      height: height ?? 50,
      decoration: BoxDecoration(
        color: purple,
        border: Border.all(color: purple),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Center(
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
    ),
  );
}

Widget myRedElevated({
  required void Function()? onPress,
  Widget? child,
  String? text,
  double? width,
  Color? color,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      height: 50,
      width: width,
      decoration: BoxDecoration(
        color: color ?? red,
        border: Border.all(color: color ?? red),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Center(
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
    ),
  );
}

Widget myGreenElevated({
  required void Function()? onPress,
  Widget? child,
  String? text,
  double? width,
  double? height,
  Color? color,
}) {
  return GestureDetector(
    onTap: onPress,
    child: Container(
      height: height ?? 50,
      width: width,
      decoration: BoxDecoration(
        color: color ?? green,
        border: Border.all(color: color ?? green),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Center(
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
      height: 50,
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
