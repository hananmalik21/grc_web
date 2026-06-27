import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PoliciesSectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const PoliciesSectionCard({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardColor = isDark ? AppColors.cardBackgroundDark : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: AppColors.dashboardCardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(11.r)),
              border: Border(bottom: BorderSide(color: AppColors.dashboardCardBorder)),
            ),
            child: Text(
              title,
              style: context.textTheme.headlineMedium?.copyWith(fontSize: 14.sp, color: AppColors.dialogTitle),
            ),
          ),
          Padding(padding: EdgeInsets.all(20.w), child: child),
        ],
      ),
    );
  }
}
