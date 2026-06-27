import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/application/candidates/controllers/delete_candidate_assessment_controller.dart';
import 'package:grc/features/hiring/application/candidates/providers/delete_candidate_assessment_providers.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/skills/candidate_skills_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/skills/skill_item_card.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/skills/assessment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidateSkillsTab extends ConsumerWidget {
  const CandidateSkillsTab({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (context.isMobileLayout) {
      return CandidateSkillsMobile(candidate: candidate, isDark: isDark);
    }

    if (candidate.skills.isEmpty && candidate.assessments.isEmpty) {
      return _buildEmptyState(context);
    }

    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final cardBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;

    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            context: context,
            title: 'Skills',
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            titleFontSize: 17.sp,
            sectionPadding: 24.r,
            contentGap: 16.h,
            isEmpty: candidate.skills.isEmpty,
            emptyMessage: 'No skills recorded for this candidate',
            textSecondary: textSecondary,
            child: Column(
              children: candidate.skills.asMap().entries.map((entry) {
                final index = entry.key;
                final skill = entry.value;
                return Padding(
                  padding: EdgeInsets.only(bottom: index == candidate.skills.length - 1 ? 0 : 12.h),
                  child: SkillItemCard(skill: skill, isDark: isDark),
                );
              }).toList(),
            ),
          ),
          Gap(24.h),
          _buildSectionCard(
            context: context,
            title: 'Assessments',
            cardBg: cardBg,
            borderColor: borderColor,
            textPrimary: textPrimary,
            titleFontSize: 17.sp,
            sectionPadding: 24.r,
            contentGap: 16.h,
            isEmpty: candidate.assessments.isEmpty,
            emptyMessage: 'No assessments recorded for this candidate',
            textSecondary: textSecondary,
            child: Column(
              children: candidate.assessments.asMap().entries.map((entry) {
                final index = entry.key;
                final assessment = entry.value;
                final isDeleting = ref.watch(deleteCandidateAssessmentLoadingProvider(assessment.assessmentGuid));
                return Padding(
                  padding: EdgeInsets.only(bottom: index == candidate.assessments.length - 1 ? 0 : 16.h),
                  child: AssessmentCard(
                    assessment: assessment,
                    candidate: candidate,
                    isDark: isDark,
                    isDeleting: isDeleting,
                    onDelete: () => ref
                        .read(deleteCandidateAssessmentControllerProvider)
                        .delete(context, assessmentGuid: assessment.assessmentGuid, candidateGuid: candidate.id),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
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

  Widget _buildSectionCard({
    required BuildContext context,
    required String title,
    required Color cardBg,
    required Color borderColor,
    required Color textPrimary,
    required double titleFontSize,
    required double sectionPadding,
    required double contentGap,
    required bool isEmpty,
    required String emptyMessage,
    required Color textSecondary,
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(sectionPadding),
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
              fontSize: titleFontSize,
            ),
          ),
          Gap(contentGap),
          if (isEmpty)
            Text(emptyMessage, style: context.textTheme.bodyMedium?.copyWith(color: textSecondary))
          else
            child,
        ],
      ),
    );
  }
}
