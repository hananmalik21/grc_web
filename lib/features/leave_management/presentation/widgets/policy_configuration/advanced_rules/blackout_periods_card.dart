import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/leave_management/domain/models/policy_configuration.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class BlackoutPeriodsCard extends StatelessWidget {
  final BlackoutPeriods blackout;
  final bool isDark;

  const BlackoutPeriodsCard({super.key, required this.blackout, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.redBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.redBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.leaveManagement.warning.path,
                width: 20,
                height: 20,
                color: AppColors.redButton,
              ),
              Gap(8.w),
              Text(
                'Blackout Periods',
                style: context.textTheme.titleMedium?.copyWith(fontSize: 14.sp, color: AppColors.redText),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(4.r),
              border: Border.all(color: AppColors.redBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4.h,
              children: [
                Text(
                  'Year-end financial close',
                  style: context.textTheme.labelMedium?.copyWith(color: AppColors.redText),
                ),
                Text(
                  blackout.fromTo.isNotEmpty ? blackout.fromTo : '2024-12-15 to 2024-12-31',
                  style: context.textTheme.labelSmall?.copyWith(color: AppColors.redButton),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
