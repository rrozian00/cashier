import '../theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    this.title,
    this.titleText,
    this.leading,
    this.actions,
  });

  final String? titleText;
  final Widget? title;
  final Widget? leading;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: white,
        shadowColor: black,
        elevation: 5,
        flexibleSpace: Stack(
          children: [
            // Background polos
            Container(color: white),

            Positioned(
              bottom: -50,
              right: -50,
              child: Container(
                margin: const EdgeInsets.all(16),
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: purple.withAlpha(50)),
              ),
            ),

            Positioned(
              left: -50,
              bottom: -50,
              child: Container(
                margin: const EdgeInsets.all(16),
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: purple.withAlpha(50)),
              ),
            ),
          ],
        ),
        title: title ??
            Text(
              titleText ?? '',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: purple,
              ),
            ),
        actions: actions,
        leading: leading);
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
