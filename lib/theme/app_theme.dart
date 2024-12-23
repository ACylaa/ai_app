import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF00FFFF); 
  static const Color secondaryColor = Color(0xFFFF00FF);
  static const Color backgroundColor = Color(0xFF0A0A1F);
  static const Color textColor = Color(0xFFFFFFFF);
  static const Color accentColor = Color(0xFF33FF33);

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: backgroundColor,
    textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: textColor,
          displayColor: textColor,
        ),
  );
}
