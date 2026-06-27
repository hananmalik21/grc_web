import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SidebarSearchSection extends StatelessWidget {
  const SidebarSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.sidebarSearchBg,
        border: Border(bottom: BorderSide(color: const Color(0xFFF3F4F6))),
      ),
      child: Container(
        height: 40.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.r),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 16.sp, color: AppColors.sidebarSecondaryText),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Search navigation...',
                style: TextStyle(fontSize: 12.3.sp, color: AppColors.sidebarSecondaryText, fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
