import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ExperienceCardMobile extends StatelessWidget {
  const ExperienceCardMobile({super.key, required this.experience, required this.isDark});

  final CandidateExperienceData experience;
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
              _CompanyIcon(isDark: isDark),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      experience.jobTitle,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textPrimary,
                        fontSize: 15.sp,
                      ),
                    ),
                    Gap(2.h),
                    Text(
                      experience.company,
                      style: context.textTheme.bodyMedium?.copyWith(color: textSecondary, fontSize: 14.sp),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gap(12.h),
          _ExperienceDetails(experience: experience, textTertiary: textTertiary),
          if (experience.isCurrent) ...[Gap(8.h), const DigifyStatusCapsule(status: 'Current')],
          Gap(12.h),
          Text(
            experience.description,
            style: context.textTheme.bodySmall?.copyWith(color: textSecondary, height: 1.5, fontSize: 13.sp),
          ),
          if (experience.achievements.isNotEmpty) ...[
            Gap(12.h),
            Text(
              'Key Achievements:',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: textSecondary,
                fontSize: 12.sp,
              ),
            ),
            Gap(6.h),
            ...experience.achievements.map(
              (achievement) => _AchievementItem(achievement: achievement, isDark: isDark, textTertiary: textTertiary),
            ),
          ],
        ],
      ),
    );
  }
}

class _CompanyIcon extends StatelessWidget {
  const _CompanyIcon({required this.isDark});

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
        assetPath: Assets.icons.leadershipIcon.path,
        color: isDark ? AppColors.primaryLight : AppColors.primary,
        width: 20.r,
        height: 20.r,
      ),
    );
  }
}

class _ExperienceDetails extends StatelessWidget {
  const _ExperienceDetails({required this.experience, required this.textTertiary});

  final CandidateExperienceData experience;
  final Color textTertiary;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 4.h,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          experience.type,
          style: context.textTheme.bodySmall?.copyWith(color: textTertiary, fontSize: 12.sp),
        ),
        DigifyStatusDot(color: textTertiary, size: 2.r),
        Text(
          experience.location,
          style: context.textTheme.bodySmall?.copyWith(color: textTertiary, fontSize: 12.sp),
        ),
        DigifyStatusDot(color: textTertiary, size: 2.r),
        Text(
          experience.duration,
          style: context.textTheme.bodySmall?.copyWith(color: textTertiary, fontSize: 12.sp),
        ),
      ],
    );
  }
}

class _AchievementItem extends StatelessWidget {
  const _AchievementItem({required this.achievement, required this.isDark, required this.textTertiary});

  final String achievement;
  final bool isDark;
  final Color textTertiary;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 6.h, left: 2.w, right: 8.w),
            child: DigifyStatusDot(color: textTertiary, size: 3.r),
          ),
          Expanded(
            child: Text(
              achievement,
              style: context.textTheme.bodySmall?.copyWith(color: textTertiary, fontSize: 12.sp, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
