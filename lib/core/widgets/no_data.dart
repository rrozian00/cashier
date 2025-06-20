import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

Widget noData({
  required String title,
  required String message,
  IconData icon = CupertinoIcons.trash_slash, // Default icon
}) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 80,
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          message,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(),
        ),
      ],
    ),
  );
}
