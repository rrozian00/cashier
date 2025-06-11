import 'colors.dart';
import 'package:flutter/material.dart';

class MyTheme {
  static const Color _black = Colors.black;
  static const Color _white = Colors.white;
  static const Color _grey = Colors.grey;
  static const Color _darkSurface = Color(0xFF1C1C1E);
  static const Color _darkOnSurface = Color(0xFFE0E0E0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: _black,
        onSecondary: softGrey,
        secondary: _grey,
        surface: _white,
        onPrimary: _white,
        onSurface: _black,
        error: Colors.redAccent,
      ),
      scaffoldBackgroundColor: softGrey,
      appBarTheme: _appBarTheme(softGrey, _black),
      textTheme: _textTheme(_black),
      cardTheme: _cardTheme(_white, _grey),
      inputDecorationTheme: _inputDecorationTheme(_white, _grey, _black),
      elevatedButtonTheme: _elevatedButtonTheme(_grey, _white),
      outlinedButtonTheme: _outlinedButtonTheme(_grey),
      dividerTheme: _dividerTheme(_grey),
      iconTheme: _iconTheme(_black),
      floatingActionButtonTheme: _fabTheme(_black, _white),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _white,
        secondary: _grey,
        surface: _darkSurface,
        onPrimary: _black,
        onSurface: _darkOnSurface,
        error: Colors.redAccent,
      ),
      scaffoldBackgroundColor: _darkSurface,
      appBarTheme: _appBarTheme(_darkSurface, _darkOnSurface),
      textTheme: _textTheme(white),
      cardTheme: _cardTheme(_darkSurface, _grey),
      inputDecorationTheme: _inputDecorationTheme(_darkSurface, _grey, _white),
      elevatedButtonTheme: _elevatedButtonTheme(_white, _black),
      outlinedButtonTheme: _outlinedButtonTheme(_white),
      dividerTheme: _dividerTheme(_grey),
      iconTheme: _iconTheme(_darkOnSurface),
      floatingActionButtonTheme: _fabTheme(_white, _black),
    );
  }

  // Komponen tema yang reusable
  static AppBarTheme _appBarTheme(
      Color backgroundColor, Color foregroundColor) {
    return AppBarTheme(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      iconTheme: IconThemeData(color: foregroundColor),
      titleTextStyle: TextStyle(
        color: foregroundColor,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      elevation: 0,
      centerTitle: true,
    );
  }

  static TextTheme _textTheme(Color textColor) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textColor,
        letterSpacing: -0.5,
      ),
      displayMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textColor,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        color: textColor,
        height: 1.5,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
        letterSpacing: 0.5,
      ),
    );
  }

  static CardTheme _cardTheme(Color cardColor, Color borderColor) {
    return CardTheme(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: borderColor, width: 0.5),
      ),
      color: cardColor,
    );
  }

  static InputDecorationTheme _inputDecorationTheme(
      Color fillColor, Color borderColor, Color focusColor) {
    return InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: focusColor, width: 1.5),
      ),
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      labelStyle: TextStyle(color: borderColor),
      hintStyle: TextStyle(color: borderColor),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme(
      Color bgColor, Color fgColor) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        foregroundColor: fgColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme(Color color) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static DividerThemeData _dividerTheme(Color color) {
    return DividerThemeData(
      color: color,
      thickness: 0.5,
      space: 1,
    );
  }

  static IconThemeData _iconTheme(Color color) {
    return IconThemeData(color: color);
  }

  static FloatingActionButtonThemeData _fabTheme(Color bgColor, Color fgColor) {
    return FloatingActionButtonThemeData(
      backgroundColor: bgColor,
      foregroundColor: fgColor,
    );
  }
}
