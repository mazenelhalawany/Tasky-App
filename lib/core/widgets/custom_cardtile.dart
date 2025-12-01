import 'package:flutter/material.dart';
import 'package:flutter_application_api_bloc/core/helper/progresscolor.dart';
import 'package:flutter_application_api_bloc/core/utils/colors.dart';
import 'package:flutter_application_api_bloc/core/utils/fonts.dart';

class CustomCardTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Color? color;
  final Color? textColor;
  final String? imageUrl;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final Color? progresscolor;
  final String? status; // ✅ جديد

  const CustomCardTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.color,
    this.textColor,
    this.imageUrl,
    this.onTap,
    this.width,
    this.height,
    this.progresscolor,
    this.status,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        color: color ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          width: width ?? double.infinity,
          height: height ?? 80,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              if (imageUrl != null)
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: AppColors.lighttextcolor.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      imageUrl!,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor ?? Colors.black,
                          fontWeight: AppFonts.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                              color: textColor ?? Colors.black,
                              fontSize: 14,
                              fontWeight: AppFonts.light),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: getStatusColor(status),
                  borderRadius: BorderRadius.circular(15),
                ),
                width: 70,
                height: 18,
                child: Center(
                  child: Text(
                    status!,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: AppFonts.semiBold,
                        fontSize: 10),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              if (icon != null) icon!
            ],
          ),
        ),
      ),
    );
  }
}
