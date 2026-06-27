import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EducationCardMobile extends StatelessWidget {
  const EducationCardMobile({super.key, required this.education, required this.isDark});

  final CandidateEducationData education;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate;
    final textTertiary = isDark ? AppColors.textTertiaryDark : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final cardBg = isDark ? AppColors.cardBackgroundDark : Colors.white;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UniversityIcon(isDark: isDark),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      education.degree,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        fontSize: 15.sp,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      education.university,
                      style: context.textTheme.bodyMedium?.copyWith(color: textSecondary, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
              if (education.isVerified) _VerifiedBadge(isDark: isDark),
            ],
          ),
          Gap(12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                education.duration,
                style: context.textTheme.bodySmall?.copyWith(color: textTertiary, fontSize: 12.sp),
              ),
              DigifyStatusDot(color: textTertiary, size: 2.r),
              Text(
                'GPA: ${education.gpa}',
                style: context.textTheme.bodySmall?.copyWith(color: textTertiary, fontSize: 12.sp),
              ),
              DigifyStatusDot(color: textTertiary, size: 2.r),
              Text(
                education.location,
                style: context.textTheme.bodySmall?.copyWith(color: textTertiary, fontSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _UniversityIcon extends StatelessWidget {
  const _UniversityIcon({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(8.r),
      ),
      alignment: Alignment.center,
      child: DigifyAsset(
        assetPath: Assets.icons.employeeSelfService.education.path,
        color: isDark ? AppColors.primaryLight : AppColors.primary,
        width: 20.r,
        height: 20.r,
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
      child: DigifyAsset(
        assetPath: Assets.icons.checkIconGreen.path,
        width: 14.w,
        height: 14.w,
        color: AppColors.primary,
      ),
    );
  }
}
