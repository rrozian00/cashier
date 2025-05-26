import 'package:bloc/bloc.dart';
import 'package:cashier/core/theme/theme_service.dart';
import 'package:equatable/equatable.dart';

part 'theme_state.dart';

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
}
