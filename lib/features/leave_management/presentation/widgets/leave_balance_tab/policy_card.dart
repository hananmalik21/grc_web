import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class PolicyCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isDark;

  const PolicyCard({super.key, required this.title, required this.description, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(7.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13.8.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1C398E),
              height: 21 / 13.8,
            ),
          ),
          Gap(7.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 12.1.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1447E6),
              height: 17.5 / 12.1,
            ),
          ),
        ],
      ),
    );
  }
}
