import 'package:flutter/material.dart';

class AppTheme {
  static const _green = Color(0xFF00A86B);
  static const _white = Colors.white;
  static const _black = Colors.black;
  static const _midBlack = Color.fromARGB(255, 41, 40, 40);
  static const _softBlack = Color.fromARGB(255, 108, 108, 108);
  static const _softGrey = Color(0xFFF5F5F5);
  static const _midGrey = Color.fromARGB(255, 233, 233, 233);
  static const _grey = Color.fromARGB(255, 122, 122, 122);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        surface: _white,
        onSurface: _midBlack,
        primary: _midBlack,
        onPrimary: _grey,
        secondary: _softGrey,
        onSecondary: _softBlack,
        error: Colors.redAccent,
        tertiary: _green,
        onTertiary: _white,
      ),
      scaffoldBackgroundColor: _midGrey,
      appBarTheme: _appBarTheme(_midGrey, _black),
      textTheme: _textTheme(_midBlack),
      cardTheme: _cardTheme(_white, _grey),
      inputDecorationTheme: _inputDecorationTheme(_white, _grey, _black),
      elevatedButtonTheme: _elevatedButtonTheme(
          const Color.fromARGB(255, 154, 153, 153), _white),
      outlinedButtonTheme: _outlinedButtonTheme(_grey),
      dividerTheme: _dividerTheme(_grey),
      iconTheme: _iconTheme(_black),
      floatingActionButtonTheme: _fabTheme(_black, _white),
      // textButtonTheme: _textButtonThemeData(_black),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        surface: _softBlack,
        onSurface: _softGrey,
        primary: _softGrey,
        onPrimary: _softGrey,
        secondary: Color.fromARGB(255, 47, 47, 47),
        onSecondary: _softGrey,
        error: Colors.redAccent,
        tertiary: _green,
        onTertiary: _white,
      ),
      scaffoldBackgroundColor: _black,
      appBarTheme: _appBarTheme(_black, _white),
      textTheme: _textTheme(_white),
      cardTheme: _cardTheme(_black, _grey),
      inputDecorationTheme: _inputDecorationTheme(_black, _grey, _white),
      elevatedButtonTheme: _elevatedButtonTheme(_grey, _softGrey),
      outlinedButtonTheme: _outlinedButtonTheme(_white),
      dividerTheme: _dividerTheme(_grey),
      iconTheme: _iconTheme(_white),
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

  static CardThemeData _cardTheme(Color cardColor, Color borderColor) {
    return CardThemeData(
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

  // static TextButtonThemeData _textButtonThemeData(Color tColor) {
  //   return TextButtonThemeData(
  //       style: TextButton.styleFrom(
  //     textStyle: TextStyle(color: tColor),
  //   ));
  // }

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
