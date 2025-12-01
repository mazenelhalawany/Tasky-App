import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.hintText,
      required this.controller,
      required this.suffixIcon,
      required this.prefixIcon,
      required this.obscureText,
      this.validator,
      this.readonly = false,
      this.ontap});
  final String hintText;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final bool readonly;
  final Function()? ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 59.h,
      margin: EdgeInsets.symmetric(horizontal: 22.w),
      child: TextFormField(
        onTap: ontap,
        readOnly: readonly,
        validator: validator,
        obscureText: obscureText,
        controller: controller,
        style: TextStyle(
            color: AppColors.boldtextcolor,
            fontSize: 14.sp,
            fontWeight: AppFonts.light),
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(vertical: 24.h), // يشيل أي padding داخلي
          isDense: true, // يمنع الزيادات
          prefixIconConstraints: BoxConstraints(
            minWidth: 10.w,
            minHeight: 10.h,
            maxWidth: 40,
            maxHeight: 40,
          ),
          suffixIconConstraints: BoxConstraints(
            minWidth: 10.w,
            minHeight: 10.h,
            maxWidth: 40,
            maxHeight: 40,
          ),

          // contentPadding: EdgeInsets.symmetric(

          //   vertical: 0.h, // هنا بيتحدد ارتفاع الـ TextField
          // ),

          // ✅ فقط لو في أيقونة نستخدم Center(child: icon)
          prefixIcon: prefixIcon != null ? Center(child: prefixIcon) : const Padding(padding: EdgeInsets.only(left: 5)),
          suffixIcon: suffixIcon != null ? Center(child: suffixIcon) : null,
          prefixStyle: const TextStyle(
            color: AppColors.boldtextcolor,
          ),

          filled: true,
          fillColor: AppColors.buttontextcolor,
          border: customBorder(),
          enabledBorder: customBorder(),
          focusedBorder: customBorder(customcolor: AppColors.buttoncolor),
          errorBorder: customBorder(customcolor: AppColors.red),
          focusedErrorBorder: customBorder(customcolor: AppColors.red),
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 14.sp,
              color: AppColors.lighttextcolor,
              fontWeight: AppFonts.light),
        ),
      ),
    );
  }
}

OutlineInputBorder customBorder(
        {Color customcolor = AppColors.textfieldcolor}) =>
    OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.r),
        borderSide: BorderSide(color: customcolor));
// import 'package:flutter/material.dart';
// import 'package:flutter_application_api_bloc/core/utils/colors.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomTextField extends StatelessWidget {
//   const CustomTextField({
//     super.key,
//     required this.hintText,
//     required this.controller,
//     required this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//   });

//   final String hintText;
//   final TextEditingController? controller;
//   final Widget prefixIcon;
//   final Widget? suffixIcon;
//   final bool obscureText;

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 59.h, // ارتفاع ثابت زي الديزاين
//       child: TextFormField(
//         controller: controller,
//         obscureText: obscureText,
//         style: const TextStyle(color: AppColors.boldtextcolor),
//         decoration: InputDecoration(
//           isDense: true, // يمنع الزيادات
//           contentPadding: EdgeInsets.zero, // يشيل أي padding داخلي

//           prefixIcon: Center(child: prefixIcon),
//           prefixIconConstraints: BoxConstraints(
//             minWidth: 10.w,
//             minHeight: 10.h,
//             maxWidth: 40,
//             maxHeight: 40,
//           ),

//           suffixIcon: Center(child: suffixIcon),
//           suffixIconConstraints: BoxConstraints(
//             minWidth: 10.w,
//             minHeight: 10.h,
//             maxWidth: 40,
//             maxHeight: 40,
//           ),

//           fillColor: AppColors.textfieldcolor,
//           filled: true,
//           border: OutlineInputBorder(
//             borderSide: const BorderSide(width: 1),
//             borderRadius: BorderRadius.circular(15.r),
//           ),
//           hintText: hintText,
//           hintStyle: TextStyle(
//             fontSize: 14.sp,
//             color: AppColors.lighttextcolor,
//           ),
//         ),
//       ),
//     );
//   }
// }
