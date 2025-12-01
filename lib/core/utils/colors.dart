
import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color buttoncolor = Color(0xFF149954);
  static const Color textfieldcolor = Color(0xFFCDCDCD);
  static const Color backgroundcolor = Color(0xFFF3F5F4);
  static const Color lighttextcolor = Color(0xFF6E6A7C);
  static const Color boldtextcolor = Color(0xFF24252C);
  static const Color buttontextcolor = Color(0xFFFFFFFF);
  static const Color splash = Color(0xFF8CD38E);
  static const Color red = Color(0xFFF44336);
  static ColorScheme lightTheme = ColorScheme.fromSeed(seedColor: buttoncolor);
  static ColorScheme darkTheme = const ColorScheme.dark(
    primary: Colors.white,
    onPrimary: Colors.black,
  );
  static const Color blackcard = Color(0xFF1D1C1B);
  static const Color greencard= Color(0xFFCEEBDC);
  static const Color pinkcard= Color(0xFFFFE4F2); 
}
