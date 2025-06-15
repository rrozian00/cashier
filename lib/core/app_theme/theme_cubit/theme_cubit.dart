import 'package:bloc/bloc.dart';
import '../theme_service.dart';

class ThemeCubit extends Cubit<bool> {
  final ThemeService _themeService;
  ThemeCubit(this._themeService) : super(false) {
    _loadTheme();
  }
  Future<void> _loadTheme() async {
    final isDark = await _themeService.isDarkMode();
    emit(isDark);
  }

  Future<void> toggleTheme() async {
    final newTheme = !state;
    await _themeService.setDarkMode(newTheme);
    emit(newTheme);
  }

  Future<void> chooseTheme(bool newTheme) async {
    // final newTheme = !state;
    await _themeService.setDarkMode(newTheme);
    emit(newTheme);
  }
}
