import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.isDark, required this.note});

  final bool isDark;
  final CandidateNote note;

  @override
  Widget build(BuildContext context) {
    final cardBorderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final cardBgColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final primaryTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final bodyTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate;
    final badgeBgColor = isDark ? AppColors.grayBgDark : AppColors.grayBg;

    return Container(
      padding: EdgeInsets.all(25.r),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: cardBorderColor, width: 1.0.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppAvatar(fallbackInitial: note.creator, size: 40.r),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(note.creator, style: context.textTheme.titleMedium?.copyWith(color: primaryTextColor)),
                    Gap(2.h),
                    Text(note.timestamp, style: context.textTheme.bodyMedium?.copyWith(color: secondaryTextColor)),
                  ],
                ),
              ),
              Gap(12.w),
              DigifyCapsule(
                label: note.scope,
                backgroundColor: badgeBgColor,
                textColor: isDark ? AppColors.textPrimaryDark : AppColors.textDarkSlate,
              ),
            ],
          ),
          Gap(12.h),
          Text(note.content, style: context.textTheme.bodyLarge?.copyWith(color: bodyTextColor)),
          Gap(12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: note.tags.map((tag) {
              return DigifyCapsule(
                label: tag,
                backgroundColor: AppColors.badgeTagBg,
                textColor: AppColors.badgeTagText,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
