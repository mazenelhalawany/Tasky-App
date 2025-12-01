import 'package:flutter_application_api_bloc/features/auth/cubit/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LogoutCubit extends Cubit<LogoutState> {
  LogoutCubit() : super(LogoutInitial());
  static LogoutCubit get(context) => BlocProvider.of(context);

  Future<void> logout() async {
    emit(LogoutLoading());

    try {
      // حذف بيانات تسجيل الدخول من SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("login_success");

      // تسجيل الخروج من Firebase (اختياري لو بتستخدمه)
      // await FirebaseAuth.instance.signOut();

      emit(LogoutSuccess());
    } catch (e) {
      emit(LogoutFailure(e.toString()));
    }
  }
}
