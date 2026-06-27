import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataClassificationComplianceCard extends StatelessWidget {
  final bool isDark;

  const DataClassificationComplianceCard({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = const [
      _ComplianceItem(title: 'Kuwait Labor Law', subtitle: 'Employee data protection requirements compliant'),
      _ComplianceItem(title: 'GDPR Standards', subtitle: 'Personal data classification aligned with global standards'),
      _ComplianceItem(title: 'Access Audit Trails', subtitle: 'All data access is logged and monitored for compliance'),
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
            'Compliance Requirements',
            style: context.textTheme.titleMedium?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(14.h),
          Column(
            spacing: 10.h,
            children: [for (final item in items) _ComplianceRow(item: item, isDark: isDark)],
          ),
        ],
      ),
    );
  }
}

class _ComplianceItem {
  final String title;
  final String subtitle;
  const _ComplianceItem({required this.title, required this.subtitle});
}

class _ComplianceRow extends StatelessWidget {
  final _ComplianceItem item;
  final bool isDark;

  const _ComplianceRow({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.25) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.infoBorderDark : AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.leaveManagement.shield.path,
            width: 18,
            height: 18,
            color: isDark ? AppColors.textSecondaryDark : AppColors.primary,
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                Gap(2.h),
                Text(
                  item.subtitle,
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
