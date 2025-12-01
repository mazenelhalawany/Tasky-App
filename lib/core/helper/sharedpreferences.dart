import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _prefs;

  // ✅ تهيئة SharedPreferences (تتعمل مرة واحدة في main)
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ✅ حفظ بيانات
  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _prefs.setString(key, value);
    if (value is int) return await _prefs.setInt(key, value);
    if (value is bool) return await _prefs.setBool(key, value);
    if (value is double) return await _prefs.setDouble(key, value);
    return false;
  }

  // ✅ جلب بيانات
  static dynamic getData({required String key}) {
    return _prefs.get(key);
  }

  // ✅ مسح بيانات (لو حبيت تعمل تسجيل خروج)
  static Future<bool> removeData({required String key}) async {
    return await _prefs.remove(key);
  }
}
