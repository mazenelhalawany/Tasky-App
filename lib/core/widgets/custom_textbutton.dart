import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget textbutton({required Function() onPressed, required String text}) {
  return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontWeight: AppFonts.regular, fontSize: 14.sp,
        color: AppColors.boldtextcolor),
      ));
}
