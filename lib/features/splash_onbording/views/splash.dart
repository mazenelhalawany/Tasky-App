import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/helper/auth_check.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/icons.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: AnimatedSplashScreen(
        animationDuration: const Duration(milliseconds: 1000),
        duration: 1500,
        splashTransition: SplashTransition.fadeTransition,
        splashIconSize: double.infinity,
        nextScreen: const AuthCheck(),
        backgroundColor: AppColors.backgroundcolor,
        splash: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSvg(
              assetName: AppIcons.logo,
              width: 334.w,
              height: 343.h,
            ),
            SizedBox(height: 44.h),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [AppColors.splash, AppColors.buttoncolor],
              ).createShader(bounds),
              child: Text(
                "Tasky",
                style: TextStyle(
                  fontSize: 37.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}