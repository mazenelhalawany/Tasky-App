import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_api_bloc/core/helper/sharedpreferences.dart';

class LocaleCubit extends Cubit<Locale> {
  static const _key = 'locale';
  static LocaleCubit get(context) => BlocProvider.of(context);

  LocaleCubit() : super(const Locale('en')); // اللغة الافتراضية

  // تحميل اللغة من التخزين
  void loadLocale() {
    final saved = CacheHelper.getData(key: _key);
    if (saved != null) emit(Locale(saved));
  }

  // تبديل اللغة
  void toggleLocale() async {
    final isEnglish = state.languageCode == 'en';
    final newLocale = isEnglish ? const Locale('ar') : const Locale('en');
    await CacheHelper.saveData(key: _key, value: newLocale.languageCode);
    emit(newLocale);
  }
}
