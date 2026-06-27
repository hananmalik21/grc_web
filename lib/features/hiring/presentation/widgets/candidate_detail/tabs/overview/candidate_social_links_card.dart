import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'candidate_section_card.dart';
import 'candidate_info_widgets.dart';

class CandidateSocialLinksCard extends StatelessWidget {
  const CandidateSocialLinksCard({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return CandidateSectionCard(
      title: 'Social & Professional Links',
      isDark: isDark,
      child: Column(
        children: [
          CandidateLinkItem(
            label: 'LinkedIn',
            value: candidate.linkedinUrl ?? 'N/A',
            assetPath: Assets.icons.hiring.linkedin.path,
            isDark: isDark,
            color: AppColors.linkedinBlue,
          ),
          Gap(12.h),
          CandidateLinkItem(
            label: 'GitHub',
            value: candidate.githubUrl ?? 'N/A',
            assetPath: Assets.icons.hiring.github.path,
            isDark: isDark,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
          Gap(12.h),
          CandidateLinkItem(
            label: 'Portfolio',
            value: candidate.portfolioUrl ?? 'N/A',
            assetPath: Assets.icons.hiring.careerSite.path,
            isDark: isDark,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}
