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

class ExperienceCard extends StatelessWidget {
  const ExperienceCard({super.key, required this.experience, required this.isDark});

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
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExperienceHeader(
            experience: experience,
            isDark: isDark,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            textTertiary: textTertiary,
          ),
          Gap(16.h),
          Text(experience.description, style: context.textTheme.bodyLarge?.copyWith(color: textSecondary)),
          if (experience.achievements.isNotEmpty) ...[
            Gap(16.h),
            Text('Key Achievements:', style: context.textTheme.titleSmall?.copyWith(color: textSecondary)),
            Gap(8.h),
            ...experience.achievements.map(
              (achievement) => _AchievementItem(achievement: achievement, isDark: isDark, textTertiary: textTertiary),
            ),
          ],
        ],
      ),
    );
  }
}

class _ExperienceHeader extends StatelessWidget {
  const _ExperienceHeader({
    required this.experience,
    required this.isDark,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
  });

  final CandidateExperienceData experience;
  final bool isDark;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CompanyIcon(isDark: isDark),
        Gap(16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(experience.jobTitle, style: context.textTheme.headlineSmall?.copyWith(color: textPrimary)),
              Gap(4.h),
              Text(experience.company, style: context.textTheme.bodyLarge?.copyWith(color: textSecondary)),
              Gap(4.h),
              _ExperienceDetails(experience: experience),
            ],
          ),
        ),
        if (experience.isCurrent) DigifyStatusCapsule(status: 'Current'),
      ],
    );
  }
}

class _CompanyIcon extends StatelessWidget {
  const _CompanyIcon({required this.isDark});

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
        assetPath: Assets.icons.leadershipIcon.path,
        color: isDark ? AppColors.primaryLight : AppColors.primary,
        width: 24.w,
        height: 24.w,
      ),
    );
  }
}

class _ExperienceDetails extends StatelessWidget {
  const _ExperienceDetails({required this.experience});

  final CandidateExperienceData experience;

  @override
  Widget build(BuildContext context) {
    final dot = Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: DigifyStatusDot(color: AppColors.textSecondary, size: 2.r),
    );

    return Row(
      children: [
        Text(
          experience.type,
          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
        dot,
        Text(
          experience.location,
          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontSize: 13.sp),
        ),
        dot,
        Text(
          experience.duration,
          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary, fontSize: 13.sp),
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
            padding: EdgeInsets.only(top: 8.h, left: 4.w, right: 12.w),
            child: DigifyStatusDot(color: textTertiary, size: 4.r),
          ),
          Expanded(
            child: Text(achievement, style: context.textTheme.bodyLarge?.copyWith(color: textTertiary)),
          ),
        ],
      ),
    );
  }
}
