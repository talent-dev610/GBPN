import 'package:flutter/material.dart';

import 'colors.dart';

class AppTheme {
  static ThemeData initialTheme() {
    return ThemeData(
      primaryColor: kPrimary,
      primaryColorDark: kPrimaryDark,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      accentColor: Colors.white,
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: kPrimary,
          primary: kPrimary,
        ),
      ),
    );
  }
}
