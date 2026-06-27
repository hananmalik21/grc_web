import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/skills/skill_item_card_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/skills/assessment_card_mobile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidateSkillsMobile extends StatelessWidget {
  const CandidateSkillsMobile({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (candidate.skills.isEmpty && candidate.assessments.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Text(
            'No skills or assessments available',
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            context: context,
            title: 'Skills',
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            isEmpty: candidate.skills.isEmpty,
            emptyMessage: 'No skills recorded for this candidate',
            child: Column(
              children: candidate.skills.asMap().entries.map((entry) {
                final index = entry.key;
                final skill = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == candidate.skills.length - 1 ? 0 : 8.h),
                  child: SkillItemCardMobile(skill: skill, isDark: isDark),
                );
              }).toList(),
            ),
          ),
          Gap(16.h),
          _buildSectionCard(
            context: context,
            title: 'Assessments',
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            isEmpty: candidate.assessments.isEmpty,
            emptyMessage: 'No assessments recorded for this candidate',
            child: Column(
              children: candidate.assessments.asMap().entries.map((entry) {
                final index = entry.key;
                final assessment = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == candidate.assessments.length - 1 ? 0 : 12.h),
                  child: AssessmentCardMobile(assessment: assessment, isDark: isDark),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required Color textSecondary,
    required bool isEmpty,
    required String emptyMessage,
    required Widget child,
  }) {
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
          Text(
            title,
            style: context.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: textPrimary,
              fontSize: 16.sp,
            ),
          ),
          Gap(12.h),
          if (isEmpty)
            Text(emptyMessage, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary))
          else
            child,
        ],
      ),
    );
  }
}
