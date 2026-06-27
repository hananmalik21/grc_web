import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// A single summary card with title and value for the employee detail screen.
class EmployeeDetailSummaryCard extends StatelessWidget {
  const EmployeeDetailSummaryCard({super.key, required this.title, required this.value, required this.isDark});

  final String title;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: context.textTheme.titleSmall?.copyWith(color: AppColors.primary)),
          Gap(4.h),
          Text(
            value,
            style: context.textTheme.titleMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
          ),
        ],
      ),
    );
  }
}
