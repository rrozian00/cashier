import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget myContainer({
  required String text,
  required void Function()? onTap,
  Color? color,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.stretch, // Pastikan stretch ke kiri-kanan
      children: [
        Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: 300, // Batasi maksimal lebar jika perlu
          ),
          decoration: BoxDecoration(
            border: Border.all(color: color ?? Colors.black),
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14),
          child: Text(
            text,
            style: GoogleFonts.poppins(
              color: color ?? Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            overflow:
                TextOverflow.ellipsis, // Hindari teks panjang melebihi batas
            maxLines: 1, // Batasi jumlah baris
            softWrap: true,
          ),
        ),
        const SizedBox(height: 8),
      ],
    ),
  );
}
