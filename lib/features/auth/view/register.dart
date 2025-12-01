import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/di/dependency_injection.dart';
import 'package:flutter_application_api_bloc/core/helper/app_validator.dart';
import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_application_api_bloc/core/utils/icons.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_image.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_spacing.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_svg.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_textbutton.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_textfeild.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/register_cubit.dart';
import 'package:flutter_application_api_bloc/features/auth/cubit/register_state.dart';
import 'package:flutter_application_api_bloc/features/auth/view/login.dart';
import 'package:flutter_application_api_bloc/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (context) => locator<RegisterCubit>(),
      child: Scaffold(
        body: SizedBox(
          child: SingleChildScrollView(
            child: BlocConsumer<RegisterCubit, RegisterState>(
              listenWhen: (previous, current) =>
                  current is RegisterSuccessState ||
                  current is RegisterErrorState,
              buildWhen: (previous, current) =>
                  (current is! RegisterSuccessState &&
                      current is! RegisterErrorState) ||
                  previous is RegisterLoadingState,
              listener: (context, state) {
                if (state is RegisterSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.successMessage),
                      backgroundColor: AppColors.buttoncolor,
                    ),
                  );
                  // Navigate to the login screen on successful registration
                  AppNavigationType.navigate(context,
                      page: const Login(), type: AppNavigation.pushReplacement);
                } else if (state is RegisterErrorState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage),
                      backgroundColor: AppColors.red,
                    ),
                  );
                }
              },
              builder: (context, state) {
                var cubit = RegisterCubit.get(context);
                return Form(
                  key: cubit.formKey,
                  child: Column(
                    children: [
                      const CustomImage(),
                      SizedBox(
                        height: 23.h,
                      ),
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
                          icon: cubit.isSecure
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
                      SizedBox(
                        height: spaceBetweenTextField,
                      ),
                      CustomTextField(
                        validator: (
                          value,
                        ) {
                          return AppValidator.validateConfirmedPassword(
                              value, cubit.passwordController.text);
                        },
                        hintText: S.of(context).confirm_password,
                        controller: cubit.confirmPasswordController,
                        prefixIcon: CustomSvg(
                          assetName: AppIcons.password,
                          width: 24.w,
                          height: 24.h,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            cubit.changeConfirmPasswordVisibility();
                          },
                          icon: cubit.isConfirmedSecure
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
                        obscureText: cubit.isConfirmedSecure,
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      state is RegisterLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : CustomButton(
                              onPressed: () {
                                cubit.userRegister(context);

                                // print("hight${300.h}");
                                // print("hight${.369.sh}");
                                // print("hight${MediaQuery.of(context).size.height * .369}");
                                // print("ScreenUtilhight${ScreenUtil().screenHeight}");
                              },
                              text: S.of(context).register),
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
                                    page: const Login(),
                                    type: AppNavigation.push);
                              },
                              text: S.of(context).login)
                        ],
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
