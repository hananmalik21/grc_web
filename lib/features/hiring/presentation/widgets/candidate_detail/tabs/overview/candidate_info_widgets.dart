import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidateInfoItem extends StatelessWidget {
  const CandidateInfoItem({super.key, required this.label, required this.value, this.assetPath, required this.isDark});

  final String label;
  final String value;
  final String? assetPath;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Row(
      children: [
        assetPath != null
            ? DigifyAsset(assetPath: assetPath!, width: 20.w, height: 20.w, color: AppColors.workPatternDisabledDayText)
            : SizedBox(width: 20.w, height: 20.w),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
              Gap(2.h),
              Text(
                value,
                style: context.textTheme.bodyLarge?.copyWith(color: textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CandidateSimpleInfoItem extends StatelessWidget {
  const CandidateSimpleInfoItem({super.key, required this.label, required this.value, required this.isDark});

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.bodyLarge?.copyWith(color: textPrimary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class CandidateSalaryItem extends StatelessWidget {
  const CandidateSalaryItem({super.key, required this.label, required this.value, required this.isDark});

  final String label;
  final String value;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary)),
        Gap(4.h),
        Row(
          children: [
            DigifyAsset(assetPath: Assets.icons.websiteIcon.path, width: 20.w, height: 20.w, color: AppColors.primary),
            Gap(8.w),
            Text(
              value,
              style: context.textTheme.titleLarge?.copyWith(color: textPrimary, fontSize: 19.sp),
            ),
          ],
        ),
      ],
    );
  }
}

class CandidateLinkItem extends StatelessWidget {
  const CandidateLinkItem({
    super.key,
    required this.label,
    required this.value,
    required this.assetPath,
    required this.isDark,
    this.color,
  });

  final String label;
  final String value;
  final String assetPath;
  final bool isDark;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          DigifyAsset(assetPath: assetPath, width: 20.w, height: 20.w, color: color ?? textPrimary),
          Gap(12.w),
          Expanded(
            child: Text(
              value,
              style: context.textTheme.bodyMedium?.copyWith(color: textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.open_in_new_rounded,
            size: 16.r,
            color: isDark ? AppColors.textMutedDark : AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
