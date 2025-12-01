import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/utils/pictures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomImage extends StatelessWidget {
  const CustomImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.plastine,
      width: double.infinity,
      height: 300.h,
      fit: BoxFit.cover,
    );
  }
}
