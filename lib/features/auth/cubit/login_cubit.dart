import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/models/user_model.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/login_state.dart';
import 'package:flutter_application_api_bloc/features/auth/data/repository/auth_repository_implement.dart';
import 'package:flutter_application_api_bloc/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this.authRepositoryImplement) : super(LoginInitialState());

  final formKey = GlobalKey<FormState>();
  bool isSecure = true;
  final AuthRepositoryImplement authRepositoryImplement;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  static LoginCubit get(context) => BlocProvider.of(context);

  Future<void> login(BuildContext context) async {
    emit(LoginLoadingState());

    if (formKey.currentState!.validate()) {
      final result = await authRepositoryImplement.login(
        user: UserModel(
          email: usernameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      // نترجم الرسالة هنا باستخدام S.of(context)
      String message;
      switch (result.message) {
        case 'Please verify your email. 📧':
          message = S.of(context).please_verify_your_email;
          break;
        case 'Wrong password provided.':
          message = S.of(context).user_not_found;
          break;
        case 'No user found for that email.':
          message = S.of(context).no_user_found;
          break;
        case 'Login successful ✅':
          message = S.of(context).loginsuccess;
          break;
        case 'Login failed':
          message = S.of(context).login_failed;
          break;
        default:
          message = S.of(context).unknown_error;
      }

      if (result.success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('login_success', true);
        emit(LoginSuccessState(message));
      } else {
        emit(LoginErrorState(result.message));
      }
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("login_success");
    emit(LoginInitialState());
  }

  void changePasswordVisibility() {
    isSecure = !isSecure;
    emit(LoginChangePasswordVisibilityState());
  }
}





// import 'package:flutter/material.dart';
// import 'package:flutter_application_api_bloc/features/auth/cubit/login_state.dart';
// import 'package:flutter_application_api_bloc/features/auth/data/model/user_model.dart';
// import 'package:flutter_application_api_bloc/features/auth/data/repository/auth_repository_implement.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class LoginCubit extends Cubit<LoginState> {
//   LoginCubit() : super(LoginInitialState());
//   final formKey = GlobalKey<FormState>();
//   bool isSecure = true;
//   AuthRepositoryImplement authRepositoryImplement = AuthRepositoryImplement();
//   bool isConfirmedSecure = true;
//   TextEditingController usernameController = TextEditingController();
//   TextEditingController passwordController = TextEditingController();
//   static LoginCubit get(context) => BlocProvider.of(context);
//   void login() async {
//     emit(LoginLoadingState());
//     // Simulate a login process

//     if (formKey.currentState!.validate()) {
//       final result = await authRepositoryImplement.login(
//         user: Usermodel(
//           email: usernameController.text.trim(),
//           password: passwordController.text.trim(),
//         ),
//       );
//       if (result.success) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setBool('login_success', true);
//         emit(LoginSuccessState(result.message));
//       } else {
//         emit(LoginErrorState(result.message));
//       }
//     }
//   }

//   void logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove("login_success");
//     emit(LoginInitialState());
//   }

//   void changePasswordVisibility() {
//     isSecure = !isSecure;
//     emit(LoginChangePasswordVisibilityState());
//   }
// }
