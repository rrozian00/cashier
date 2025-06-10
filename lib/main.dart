import 'package:cashier/core/theme/cubit/theme_cubit.dart';
import 'package:cashier/core/theme/my_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/app_providers/app_providers.dart';
import 'firebase_options.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
