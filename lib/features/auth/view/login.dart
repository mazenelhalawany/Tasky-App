import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/di/dependency_injection.dart';
import 'package:flutter_application_api_bloc/core/helper/app_validator.dart';
import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
import 'package:flutter_application_api_bloc/core/services/firebase_auth_service.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_application_api_bloc/core/utils/icons.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_image.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_spacing.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_svg.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_textbutton.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_textfeild.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/login_cubit.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/login_state.dart';
import 'package:flutter_application_api_bloc/features/auth/view/register.dart';
import 'package:flutter_application_api_bloc/features/home/views/home.dart';
import 'package:flutter_application_api_bloc/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuthService authRepository = FirebaseAuthService();

    return BlocProvider(
      create: (context) => locator<LoginCubit>(),
      child: Scaffold(
        body: SizedBox(
          child: SingleChildScrollView(
            child: Column(children: [
              // BlocListener<LoginCubit, LoginState>(
              //     listener: (context, state) {
              //       if (state is LoginChangePasswordVisibilityState) {
              //         print("ChangePasswordVisibilityState");
              //         AppNavigationType.navigate(context,
              //             page: const Register(), type: AppNavigation.push);
              //       } else {
              //         print("false");
              //       }
              //     },
              //     child: Container()),
              BlocConsumer<LoginCubit, LoginState>(
                listenWhen: (previous, current) =>
                    current is LoginSuccessState || current is LoginErrorState,
                listener: (context, state) {
                  if (state is LoginSuccessState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage),
                        backgroundColor: AppColors.buttoncolor,
                      ),
                    );
                    AppNavigationType.navigate(
                      context,
                        page: Home(userId: authRepository.currentUser!.uid),
                      type: AppNavigation.pushAndRemoveUntil,
                    );
                    // Navigate to the login screen on successful registration
                  //   AppNavigationType.navigate(context,
                  //       page: Home(userId: authRepository.currentUser!.uid),
                  //       type: AppNavigation.pushReplacement);
                   } else if (state is LoginErrorState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage),
                        backgroundColor: AppColors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  final cubit = LoginCubit.get(context);
                  return Column(
                    children: [
                      const CustomImage(),
                      SizedBox(
                        height: 23.h,
                      ),
                      Form(
                        key: cubit.formKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              validator: AppValidator.validateEmail,
                              hintText: S.of(context).username,
                              controller: cubit.usernameController,
                              prefixIcon: CustomSvg(
                                assetName: AppIcons.profile,
                                width: 24.w,
                                height: 24.h,
                              ),
                              suffixIcon: null,
                              obscureText: false,
                            ),
                            SizedBox(
                              height: spaceBetweenTextField,
                            ),
                            CustomTextField(
                              validator: AppValidator.validatePassword,
                              hintText: S.of(context).password,
                              controller: cubit.passwordController,
                              prefixIcon: CustomSvg(
                                assetName: AppIcons.password,
                                width: 24.w,
                                height: 24.h,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  cubit.changePasswordVisibility();
                                },
                                icon: LoginCubit.get(context).isSecure
                                    ? CustomSvg(
                                        assetName: AppIcons.unlock,
                                        width: 24.w, // 👈 نفس القيمة جوه
                                        height: 24.h,
                                      )
                                    : CustomSvg(
                                        assetName: AppIcons.lock,
                                        width: 24.w, // 👈 نفس القيمة جوه
                                        height: 24.h,
                                      ),
                              ),
                              obscureText: cubit.isSecure,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      CustomButton(
                          onPressed: () {
                            cubit.login(
                              context,
                            );
                            // print("hight${300.h}");
                            // print("hight${.369.sh}");
                            // print("hight${MediaQuery.of(context).size.height * .369}");
                            // print("ScreenUtilhight${ScreenUtil().screenHeight}");
                          },
                          text: S.of(context).login),
                      SizedBox(
                        height: 40.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            S.of(context).donthaveaccount,
                            style: TextStyle(
                                fontWeight: AppFonts.extralight,
                                fontSize: 14.sp),
                          ),
                          textbutton(
                              onPressed: () {
                                AppNavigationType.navigate(context,
                                    page: const Register(),
                                    type: AppNavigation.push);
                              },
                              text: S.of(context).register)
                        ],
                      ),
                      CustomButton(
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('onboarding_seen', false);
                        },
                        text: S.of(context).delete,
                      ),
                    ],
                  );
                },
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
