import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EducationCard extends StatelessWidget {
  const EducationCard({super.key, required this.education, required this.isDark});

  final CandidateEducationData education;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final cardBg = isDark ? AppColors.cardBackgroundDark : Colors.white;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _UniversityIcon(isDark: isDark),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(education.degree, style: context.textTheme.headlineSmall?.copyWith(color: textPrimary)),
                          Gap(4.h),
                          Text(
                            education.university,
                            style: context.textTheme.bodyLarge?.copyWith(color: textSecondary),
                          ),
                          Gap(4.h),
                          Text(
                            education.location,
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 13.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (education.isVerified) _VerifiedBadge(isDark: isDark),
                  ],
                ),
                Gap(12.h),
                Row(
                  children: [
                    Text(
                      education.duration,
                      style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontSize: 13.sp),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: DigifyStatusDot(color: AppColors.textSecondary, size: 2.r),
                    ),
                    Text(
                      'GPA: ${education.gpa}',
                      style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontSize: 13.sp),
                    ),
                  ],
                ),
              ],
            ),
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
      width: 48.r,
      height: 48.r,
      decoration: BoxDecoration(
        color: isDark ? AppColors.primary.withValues(alpha: 0.2) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
      ),
      alignment: Alignment.center,
      child: DigifyAsset(
        assetPath: Assets.icons.employeeSelfService.education.path,
        color: isDark ? AppColors.primaryLight : AppColors.primary,
        width: 24.w,
        height: 24.w,
      ),
    );
  }
}

class _VerifiedBadge extends StatelessWidget {
  const _VerifiedBadge({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DigifyAsset(assetPath: Assets.icons.checkIconGreen.path, width: 16.w, height: 16.w, color: AppColors.primary),
        Gap(4.w),
        Text('Verified', style: context.textTheme.titleSmall?.copyWith(color: AppColors.primary)),
      ],
    );
  }
}
