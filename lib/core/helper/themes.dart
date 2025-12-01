import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class AppTheme {
  static final lightTheme = ThemeData(
    fontFamily: 'Lexend_Deca',
    appBarTheme: const AppBarTheme().copyWith(
      titleTextStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: AppFonts.light,
          color: AppColors.buttontextcolor),
      backgroundColor: AppColors.lightTheme.primary,
      foregroundColor: AppColors.lightTheme.onPrimary,
    ),
    colorScheme: AppColors.lightTheme,
    scaffoldBackgroundColor: AppColors.backgroundcolor,
    brightness: Brightness.light,
    useMaterial3: true,
  );

  static final darkTheme = ThemeData(
    fontFamily: 'Lexend_Deca',
    appBarTheme: const AppBarTheme().copyWith(
      titleTextStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: AppFonts.light,
          color: AppColors.buttontextcolor),
      backgroundColor: AppColors.darkTheme.onPrimary,
      foregroundColor: AppColors.darkTheme.primary,
    ),
    colorScheme: AppColors.darkTheme,
    scaffoldBackgroundColor: const Color(0xFF121212),
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
