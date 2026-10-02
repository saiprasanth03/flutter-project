import 'package:flutter/material.dart';

class AppTheme {
  static const green = Color(0xFF286647);
  static const ink = Color(0xFF17251D);
  static const muted = Color(0xFF69766E);
  static const canvas = Color(0xFFF5F7F2);

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: green, brightness: Brightness.light)
        .copyWith(surface: Colors.white, primary: green, onSurface: ink),
    scaffoldBackgroundColor: canvas,
    appBarTheme: const AppBarTheme(
      backgroundColor: canvas,
      foregroundColor: ink,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(color: ink, fontSize: 17, fontWeight: FontWeight.w700),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 1,
      shadowColor: const Color(0x1A17251D),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: Color(0xFFE5EAE4))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: green, width: 1.5)),
    ),
    chipTheme: ChipThemeData(
      shape: const StadiumBorder(),
      side: BorderSide.none,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFFDCEBDF),
      padding: const EdgeInsets.symmetric(horizontal: 5),
    ),
  );
}
