import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              "assets/icons/icon.png",
              color: Theme.of(context).colorScheme.primary,
              width: MediaQuery.of(context).size.width / 2.5,
            ),
            Text(
              "Cashier",
              style: GoogleFonts.lobster(
                  fontSize: 50, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
    );

    // BlocListener<AuthBloc, AuthState>(
    //   bloc: context.read<AuthBloc>()..add(AuthCheckStatusEvent()),
    //   listener: (context, state) async {
    //     await Future.delayed(Duration(milliseconds: 500));

    //     if (state is AuthLoggedState) {
    //       try {
    //         if (context.mounted) {
    //           Navigator.pushReplacement(
    //               context,
    //               MaterialPageRoute(
    //                 builder: (context) => BottomView(),
    //               ));
    //         }
    //       } catch (e) {
    //         debugPrint("error route:$e");
    //       }
    //     } else if (state is UnauthenticatedState || state is AuthFailedState) {
    //       if (context.mounted) {
    //         Navigator.pushReplacement(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => LoginView(),
    //             ));
    //       }
    //     }
    //   },
    //   child: Scaffold(
    //     body: Center(
    //       child: Column(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           Image.asset(
    //             "assets/icons/icon.png",
    //             color: Theme.of(context).colorScheme.primary,
    //             width: MediaQuery.of(context).size.width / 2.5,
    //           ),
    //           Text(
    //             "Cashier",
    //             style: GoogleFonts.lobster(
    //                 fontSize: 50, fontWeight: FontWeight.w600),
    //           )
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
