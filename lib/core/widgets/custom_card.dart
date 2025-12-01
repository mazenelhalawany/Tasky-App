import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/helper/navigation.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';
import 'package:flutter_application_api_bloc/core/widgets/custom_button.dart';
import 'package:flutter_application_api_bloc/features/add_task/views/tasks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.cardColor,
    required this.iconColor,
    this.width,
    this.height,
    this.titlesize,
    this.descriptionsize,
    this.sizedbox,
    this.needButton = false,
    this.isBlack=false,
  });
  final String title;
  final String description;
  final Widget?
      icon; // 👈 هنا بدل IconData أو Icon خلتها Widget عشان أقبل أي نوع
  final double? width;
  final double? height;
  final Color cardColor;
  final bool isBlack;
  final Color? iconColor;
  final double? titlesize;
  final double? descriptionsize;
  final double? sizedbox;
  final bool? needButton;

  @override
  Widget build(BuildContext context) {
  //  final cubit = TasksCubit.get(context);

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0.r),
      ),
      elevation: 5,
      child: Container(
        width: width ?? 235.w,
        height: height ?? 90.w,
        padding: const EdgeInsets.symmetric(
          vertical: 15.0,
          horizontal: 22.0,
        ).w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.backgroundcolor,
                    fontSize: titlesize ?? 14.sp,
                    fontWeight: AppFonts.regular,
                  ),
                ),
                if (icon != null) icon!, // 👈 لو الأيقونة موجودة، اعرضها
              ],
            ),
            SizedBox(height: sizedbox ?? 5),
            Row(
              children: [
                Expanded(
                  child: Text(
                    description,
                    style: TextStyle(
                      color: isBlack? AppColors.backgroundcolor:AppColors.blackcard,
                      fontSize: descriptionsize ?? 12.sp,
                      fontWeight: AppFonts.light,
                    ),
                  ),
                ),
                if (needButton == true)
                  Expanded(
                    child: CustomButton(
                      buttoncolor: AppColors.backgroundcolor,
                      textcolor: AppColors.buttoncolor,
                      onPressed: () {
                        AppNavigationType.navigate(
                          context,
                          page: const TasksScreen(),
                          type: AppNavigation.pushReplacement,
                        );
                      },
                      text: "view Tasks",
                    ),
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
