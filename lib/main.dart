import 'package:cashier/app/modules/bottom/controllers/bottom_controller.dart';
import 'package:cashier/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(BottomController());
  await initializeDateFormatting('id_ID', null).then((_) {
    runApp(
      GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Application",
        // initialRoute: AppPages.INITIAL,
        home: AuthChecker(),
        getPages: AppPages.routes,
      ),
    );
  });
}

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
            Get.offAllNamed(Routes.BOTTOM);
          } else {
            Get.offAllNamed(Routes.LOGIN);
          }
        });

        return const Scaffold(
            body: SizedBox()); // Return widget kosong sementara
      },
    );
  }
}
