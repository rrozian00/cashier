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
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 2,
              blurRadius: 4,
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

//   const MyCard({
//     this.image,
//     this.title,
//     this.subtitle,
//     this.color,
//     super.key,
//   });

//   final String? title;
//   final String? image;
//   final String? subtitle;
//   final Color? color;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: softGrey,
//         // borderRadius: BorderRadius.circular(15),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(16),
//         child: Row(
//           children: [
//             // Icon Pendapatan atau Pengeluaran
//             CircleAvatar(
//               backgroundColor: color?.withAlpha(70),
//               radius: 25,
//               child: Image.asset(
//                 image ?? 'assets/icons/icon.png',
//                 height: 35,
//                 width: 35,
//               ),
//             ),
//             SizedBox(width: 20),

//             // Teks Deskripsi
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title ?? '-',
//                     style: GoogleFonts.irishGrover(
//                       color: white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     subtitle ?? '-',
//                     style: GoogleFonts.montserrat(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                       color: color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
