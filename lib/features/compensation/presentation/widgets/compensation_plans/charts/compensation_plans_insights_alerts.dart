import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../compensation_plans_config.dart';

class CompInsightsAlerts extends StatelessWidget {
  const CompInsightsAlerts({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final alert in CompensationPlansConfig.insightAlerts)
            InsightTile(
              title: alert.title,
              subtitle: alert.subtitle,
              backgroundColor: alert.backgroundColor,
              borderColor: alert.borderColor,
              iconColor: alert.iconColor,
              iconPath: alert.iconPath,
            ),
        ],
      ),
    );
  }
}

class InsightTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final String iconPath;

  const InsightTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(assetPath: iconPath, width: 18.w, height: 18.h, color: iconColor),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.titleSmall),
                Gap(4.h),
                Text(
                  subtitle,
                  style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
