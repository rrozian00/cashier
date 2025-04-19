// Widget Custom untuk Menampilkan Data dalam Card yang Elegan
import 'package:cashier/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatelessWidget {
  const MyCard({
    this.image,
    this.title,
    this.subtitle,
    this.color,
    super.key,
  });

  final String? title;
  final String? image;
  final String? subtitle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: softGrey,
        // borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon Pendapatan atau Pengeluaran
            CircleAvatar(
              backgroundColor: color?.withAlpha(70),
              radius: 25,
              child: Image.asset(
                image ?? 'assets/icons/icon.png',
                height: 35,
                width: 35,
              ),
            ),
            SizedBox(width: 20),

            // Teks Deskripsi
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title ?? '-',
                    style: GoogleFonts.irishGrover(
                      color: purple,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle ?? '-',
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
