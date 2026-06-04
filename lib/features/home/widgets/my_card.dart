import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyCard extends StatelessWidget {
  const MyCard(
      {super.key,
      required this.image,
      required this.title,
      required this.subtitle,
      this.color});

  final String title;
  final String subtitle;
  final String image;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 150,
        width: 300,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onPrimary,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.secondary,
              spreadRadius: 8,
              blurRadius: 8,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      image,
                      scale: 10,
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                        fontSize: 25, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
