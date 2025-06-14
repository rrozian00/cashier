import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/app_providers/app_providers.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'core/theme/my_theme.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: "https://brqjvmfmchyelexiinvw.supabase.co",
      anonKey:
          "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJycWp2bWZtY2h5ZWxleGlpbnZ3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDk4NjQxMzksImV4cCI6MjA2NTQ0MDEzOX0.LGIwF48jKnw8kFZA2NsJgj3ldi1WRb4sG5h7KZJavEg");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeDateFormatting('id_ID', null).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: appProviders,
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDarkMode) {
          return GetMaterialApp(
            theme: isDarkMode ? MyTheme.darkTheme : MyTheme.lightTheme,
            title: "Cashier",
            initialRoute: AppPages.initial,
            getPages: AppPages.routes,
          );
        },
      ),
    );
  }
}
