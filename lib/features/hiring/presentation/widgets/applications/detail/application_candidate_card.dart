import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'application_detail_section.dart';

class ApplicationCandidateCard extends StatelessWidget {
  const ApplicationCandidateCard({required this.detail, super.key});

  final ApplicationDetailData detail;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final subtitle = detail.candidateSubtitle;

    return ApplicationDetailSection(
      title: 'Candidate',
      actionLabel: 'View Profile',
      onActionPressed: () {},
      child: Row(
        children: [
          AppAvatar(size: 50.w, fallbackInitial: detail.candidateName),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detail.candidateName,
                  style: context.textTheme.titleSmall?.copyWith(color: primaryText, fontSize: 15.sp),
                ),
                Gap(4.h),
                Text(detail.candidateEmail, style: context.textTheme.bodyMedium?.copyWith(color: secondaryText)),
                if (subtitle.isNotEmpty)
                  Text(subtitle, style: context.textTheme.bodyMedium?.copyWith(color: secondaryText)),
                if (detail.candidateLocation != null && detail.candidateLocation!.isNotEmpty) ...[
                  Gap(4.h),
                  Text(detail.candidateLocation!, style: context.textTheme.bodyMedium?.copyWith(color: secondaryText)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
