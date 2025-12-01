import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCardTileHome extends StatelessWidget {
  const CustomCardTileHome({
    super.key,
    required this.title,
    required this.count,
    required this.icon,
    this.iconBackgroundColor = Colors.grey,
    this.countBackgroundColor = Colors.black,
    this.titleColor = Colors.black,
  });

  final String title;
  final int count;
  final IconData icon;
  final Color iconBackgroundColor;
  final Color countBackgroundColor;
  final Color titleColor;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        child: Row(
          children: [
            // أيقونة داخل دائرة
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: iconBackgroundColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconBackgroundColor, size: 20.sp),
            ),
            SizedBox(width: 12.w),
            // العنوان
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: titleColor,
                ),
              ),
            ),
            // العداد
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: countBackgroundColor,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
