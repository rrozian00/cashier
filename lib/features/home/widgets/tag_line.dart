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
          color: Theme.of(context).colorScheme.primary,
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

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// class TagLineWidget extends StatelessWidget {
//   const TagLineWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final shadow = Shadow(
//         blurRadius: 15,
//         color: Theme.of(context).colorScheme.primary,
//         offset: Offset(0.5, 0.5));

//     return Row(
//       children: [
//         Text(
//           "for simplicity, use",
//           style: TextStyle(
//             shadows: [shadow],
//             fontSize: 18,
//             color: Theme.of(context).colorScheme.surface,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         SizedBox(width: 10),
//         Text(
//           "Cashier !!!",
//           style: GoogleFonts.lobster(
//             // shadows: [shadow],
//             color: Theme.of(context).colorScheme.primary,
//             fontSize: 35,
//             fontWeight: FontWeight.w800,
//           ),
//         ),
//       ],
//     );
//   }
// }
