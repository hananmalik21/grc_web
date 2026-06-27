import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/security_manager/presentation/providers/data_classification/data_classification_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataClassificationGuidelinesCard extends StatelessWidget {
  final bool isDark;

  const DataClassificationGuidelinesCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _GuidelineItem(type: DataClassificationType.public),
      _GuidelineItem(type: DataClassificationType.confidential),
      _GuidelineItem(type: DataClassificationType.restricted),
    ];

    return Container(
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Classification Guidelines',
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(14.h),
          Column(
            spacing: 10.h,
            children: [for (final item in items) _GuidelineRow(type: item.type, isDark: isDark)],
          ),
        ],
      ),
    );
  }
}

class _GuidelineItem {
  final DataClassificationType type;
  const _GuidelineItem({required this.type});
}

class _GuidelineRow extends StatelessWidget {
  final DataClassificationType type;
  final bool isDark;

  const _GuidelineRow({required this.type, required this.isDark});

  Color get _iconColor => switch (type) {
    DataClassificationType.public => AppColors.primary,
    DataClassificationType.confidential => AppColors.warning,
    DataClassificationType.restricted => AppColors.error,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.tableHeaderBackground : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(assetPath: type.iconPath, width: 18, height: 18, color: _iconColor),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${type.label} Data',
                  style: context.textTheme.labelLarge?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(2.h),
                Text(
                  type.subtitle,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
