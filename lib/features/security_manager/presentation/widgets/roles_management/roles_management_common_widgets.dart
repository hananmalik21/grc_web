import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RolesManagementStatsCardData {
  const RolesManagementStatsCardData({
    required this.title,
    required this.value,
    required this.iconPath,
    this.subtitle,
    this.iconBackgroundColor,
    this.iconColor,
  });

  final String title;
  final String value;
  final String iconPath;
  final String? subtitle;
  final Color? iconBackgroundColor;
  final Color? iconColor;
}

class RolesManagementStatsCard extends StatelessWidget {
  const RolesManagementStatsCard({super.key, required this.data});

  final RolesManagementStatsCardData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final subtitle = data.subtitle;

    return Container(
      padding: EdgeInsets.all(13.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.title,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 12.sp,
                ),
              ),
              Gap(4.h),
              Text(
                data.value,
                style: context.textTheme.displaySmall?.copyWith(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              if (subtitle != null) ...[
                Gap(4.h),
                Text(
                  subtitle,
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w500),
                ),
              ],
            ],
          ),
          Container(
            width: 41.w,
            height: 41.w,
            decoration: BoxDecoration(
              color:
                  data.iconBackgroundColor ??
                  (isDark ? AppColors.infoBgDark.withValues(alpha: 0.18) : AppColors.infoBg),
              borderRadius: BorderRadius.circular(7.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(
              assetPath: data.iconPath,
              width: 20,
              height: 20,
              color: data.iconColor ?? AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class RolesManagementMetaLine extends StatelessWidget {
  const RolesManagementMetaLine({super.key, required this.iconPath, required this.text});

  final String iconPath;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAsset(
          assetPath: iconPath,
          width: 14,
          height: 14,
          color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
        Gap(6.w),
        Text(
          text,
          style: context.textTheme.bodySmall?.copyWith(
            color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class RolesManagementPresetChip extends StatelessWidget {
  const RolesManagementPresetChip({super.key, required this.label, this.isSelected = false, this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(7.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.jobRoleBg
              : (context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackground),
          borderRadius: BorderRadius.circular(7.r),
          border: Border.all(
            color: isSelected
                ? AppColors.infoBorder
                : (context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
          ),
        ),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: isSelected
                ? AppColors.primary
                : (context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ),
        ),
      ),
    );
  }
}

class RolesManagementRiskChip extends StatelessWidget {
  const RolesManagementRiskChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppColors.orangeBg,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: AppColors.orangeBorder),
      ),
      child: Text(
        'RISKY',
        style: context.textTheme.labelSmall?.copyWith(
          color: AppColors.orange,
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class RolesManagementPermissionCell extends StatelessWidget {
  const RolesManagementPermissionCell({super.key, required this.value, this.onChanged});

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Center(
        child: DigifyCheckbox(value: value, onChanged: onChanged),
      ),
    );
  }
}

class RolesManagementCompactUserChip extends StatelessWidget {
  const RolesManagementCompactUserChip({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(999.r),
        border: Border.all(color: context.isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAvatar(fallbackInitial: name, size: 26.w, backgroundColor: AppColors.primary),
          Gap(8.w),
          Text(
            name,
            style: context.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: context.isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class RolesManagementEmptyBody extends StatelessWidget {
  const RolesManagementEmptyBody({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h),
      alignment: Alignment.center,
      child: Text(
        message,
        style: context.textTheme.bodySmall?.copyWith(
          color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}
