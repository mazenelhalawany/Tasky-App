import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/models/user_model.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/register_state.dart';
import 'package:flutter_application_api_bloc/features/auth/data/repository/auth_repository_implement.dart';
import 'package:flutter_application_api_bloc/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this.authRepositoryImplement) : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);
  AuthRepositoryImplement authRepositoryImplement ;

  bool isSecure = true;
  bool isConfirmedSecure = true;
  final formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void changePasswordVisibility() {
    isSecure = !isSecure;
    emit(RegisterChangePasswordVisibilityState());
  }

  void changeConfirmPasswordVisibility() {
    isConfirmedSecure = !isConfirmedSecure;
    emit(RegisterConfirmChangePasswordVisibilityState());
  }

  userRegister(context) async {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoadingState());

      final result = await authRepositoryImplement.register(
        user: UserModel(
          email: usernameController.text.trim(),
          password: passwordController.text.trim(),
        ),
      );

      String message;
      switch (result.message) {
        case 'successful verify your email.':
          message = S.of(context).please_verify_your_email;
          break;
        case 'The password provided is too weak.':
          message = S.of(context).weak_password;
          break;
        case 'The account already exists .':
          message = S.of(context).account_already_exists;
          break;
        default:
          message = S.of(context).unknown_error;
      }

      if (result.success) {
        emit(RegisterSuccessState(message));
      } else {
        emit(RegisterErrorState(result.message));
      }
    }
  }
}
