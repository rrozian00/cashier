import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StoreName extends StatelessWidget {
  const StoreName({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Icon(
            shadows: [
              Shadow(
                blurRadius: 2,
                color: Theme.of(context).colorScheme.primary,
                offset: Offset(1, 1),
              )
            ],
            Icons.store_rounded,
            size: 70,
          ),
          Text(
            'Nama Toko',
            style: GoogleFonts.pacifico(
              shadows: [
                Shadow(
                  blurRadius: 2,
                  color: Theme.of(context).colorScheme.primary,
                  offset: Offset(1, 1),
                )
              ],
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
