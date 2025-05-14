import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../features/user/blocs/auth/auth_bloc.dart';
import '../../routes/app_pages.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: context.read<AuthBloc>()..add(AuthCheckStatusEvent()),
      listener: (context, state) async {
        debugPrint("AuthBloc state: $state");

        await Future.delayed(Duration(milliseconds: 500));

        if (state is AuthLoggedState) {
          try {
            if (context.mounted) {
              Navigator.pushReplacementNamed(context, Routes.bottom);
            }

            debugPrint("harusnya udah route");
          } catch (e) {
            debugPrint("error route:$e");
          }
        } else if (state is UnauthenticatedState || state is AuthFailedState) {
          if (context.mounted) {
            Navigator.pushReplacementNamed(context, Routes.login);
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset("assets/icons/icon.png"),
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
