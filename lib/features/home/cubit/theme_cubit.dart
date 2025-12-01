import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  static const String _key = 'theme_mode';
  static ThemeCubit get(context) => BlocProvider.of(context);

  // 🧠 تحميل الثيم المحفوظ
  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_key) ?? false;
    emit(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  // 🌞 التبديل بين الوضعين
  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = state == ThemeMode.dark;
    await prefs.setBool(_key, !isDark);
    emit(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
