import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_application_api_bloc/core/utils/icons.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_svg.dart';
import 'package:flutter_application_api_bloc/features/auth/view/register.dart';
import 'package:flutter_application_api_bloc/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Onbording extends StatelessWidget {
  const Onbording({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  right: 37.w,
                  left: 37.w,
                  top: 90.h,
                ),
                child: CustomSvg(
                  assetName: AppIcons.objects,
                  width: 300.w,
                  height: 343.h,
                ),
              ),
              SizedBox(
                height: 59.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 114.w,
                ),
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    S.of(context).welcome_tasky,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: AppFonts.regular,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 40.h,
              ),
              Text(
                textAlign: TextAlign.center,
                S.of(context).onbording_subtitle,
                style: TextStyle(
                  color: AppColors.lighttextcolor,
                  fontSize: 15.sp,
                  fontWeight: AppFonts.medium,
                ),
              ),
              SizedBox(
                height: 55.h,
              ),
              CustomButton(
                  onPressed: () {
                    AppNavigationType.navigate(context,
                        page: const Register(), type: AppNavigation.push);
                  },
                  text: S.of(context).lets_start),
            ],
          ),
        ),
      ),
    );
  }
}
