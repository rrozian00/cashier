import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TagLineWidget extends StatelessWidget {
  const TagLineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          textAlign: TextAlign.end,
          "simplicity?",
          style: TextStyle(
            fontSize: 18,
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 5),
        Image.asset(
          "assets/icons/icon.png",
          width: 35,
          height: 35,
        ),
        Text(
          "Cashier !!!",
          style: GoogleFonts.lobster(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
