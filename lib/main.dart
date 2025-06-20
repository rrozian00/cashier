import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'core/app_observer/app_observer.dart';
import 'core/app_providers/app_providers.dart';
import 'core/app_theme/my_theme.dart';
import 'core/app_theme/theme_cubit/theme_cubit.dart';
import 'core/firebase/firebase_options.dart';
import 'core/supabase/supabase_init.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseInit.supabaseInit();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();
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
          return MaterialApp(
            theme: isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme,
            title: "Cashier",
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
