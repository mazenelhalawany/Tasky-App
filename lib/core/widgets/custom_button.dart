import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.buttoncolor,
      this.textcolor});
  final VoidCallback? onPressed;
  final String text;
  final Color? buttoncolor;
  final Color? textcolor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.buttoncolor)),
      width: double.infinity,
      // height: 48.h,
      margin: EdgeInsets.symmetric(horizontal: 22.w),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15.h),
              shadowColor: AppColors.buttoncolor,
              elevation: 10,
              backgroundColor: buttoncolor ?? AppColors.buttoncolor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(14.r)))),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
                color: textcolor ?? AppColors.buttontextcolor,
                fontSize: 19.sp,
                fontFamily: 'Lexend_Deca',
                fontWeight: AppFonts.extralight),
          )),
    );
  }
}
