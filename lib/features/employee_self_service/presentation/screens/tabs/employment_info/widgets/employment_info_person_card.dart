import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/employee_self_service/presentation/providers/employment_info/employment_info_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmploymentInfoPersonCard extends StatelessWidget {
  final ReportingPersonInfo person;
  final String iconPath;
  final Color iconBackgroundColor;
  final Color iconColor;

  const EmploymentInfoPersonCard({
    super.key,
    required this.person,
    required this.iconPath,
    required this.iconBackgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(13.5.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: iconBackgroundColor, shape: BoxShape.circle),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: iconPath, width: 22, height: 22, color: iconColor),
          ),
          Gap(13.5.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.label,
                  style: context.textTheme.labelLarge?.copyWith(fontSize: 12.sp, color: AppColors.sidebarCategoryText),
                ),
                Gap(2.h),
                Text(
                  person.name,
                  style: context.textTheme.headlineMedium?.copyWith(fontSize: 14.sp, color: context.themeTextPrimary),
                ),
                Gap(2.h),
                Text(
                  person.subtitle,
                  style: context.textTheme.labelSmall?.copyWith(fontSize: 12.sp, color: AppColors.sidebarSecondaryText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
