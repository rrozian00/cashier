import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../navbar/views/navbar_view.dart';
import '../../user/login/views/login_view.dart';
import '../bloc/splash_screen_bloc.dart';

class SplashScreenView extends StatelessWidget {
  const SplashScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashScreenBloc, SplashScreenState>(
      listener: (context, state) {
        Future.delayed(Duration(milliseconds: 500));

        if (state is AuthenticationSuccess) {
          try {
            if (context.mounted) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NavbarView(),
                  ));
            }
          } catch (e) {
            debugPrint("error route:$e");
          }
        } else if (state is AuthenticationError) {
          if (context.mounted) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginView(),
                ));
          }
        }
      },
      child: Scaffold(
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
      ),
    );
  }
}
