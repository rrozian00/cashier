import 'package:cashier/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// 🔹 Widget untuk cek status login user
class AuthChecker extends StatelessWidget {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  AuthChecker({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // 🔹 Pakai Future.microtask supaya navigasi tidak dijalankan di tengah build()
        Future.microtask(() {
          if (snapshot.hasData) {
            Get.offAllNamed(Routes.bottom);
          } else {
            Get.offAllNamed(Routes.login);
          }
        });

        return const Scaffold(
            body: SizedBox()); // Return widget kosong sementara
      },
    );
  }
}
