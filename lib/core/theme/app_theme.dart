import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue,
      textTheme: GoogleFonts.interTextTheme(),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.blue,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      useMaterial3: true,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
      ),
    );
  }
}
