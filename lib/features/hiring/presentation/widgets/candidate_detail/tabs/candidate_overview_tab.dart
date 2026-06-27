import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'overview/candidate_background_check_card.dart';
import 'overview/candidate_compensation_card.dart';
import 'overview/candidate_contact_info_card.dart';
import 'overview/candidate_personal_info_card.dart';
import 'overview/candidate_professional_summary_card.dart';
import 'overview/candidate_quick_actions_card.dart';
import 'overview/candidate_resume_card.dart';
import 'overview/candidate_social_links_card.dart';
import 'overview/candidate_source_card.dart';

class CandidateOverviewTab extends StatelessWidget {
  const CandidateOverviewTab({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktopLayout;
    final sectionSpacing = ResponsiveHelper.getTabSectionSpacing(context);
    final padding = ResponsiveHelper.getDetailScreenPadding(context);

    return SingleChildScrollView(
      padding: padding,
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      CandidateContactInfoCard(candidate: candidate, isDark: isDark),
                      Gap(sectionSpacing),
                      CandidateProfessionalSummaryCard(candidate: candidate, isDark: isDark),
                      if (candidate.hasResume) ...[
                        Gap(sectionSpacing),
                        CandidateResumeCard(candidate: candidate, isDark: isDark),
                      ],
                      Gap(sectionSpacing),
                      CandidateCompensationCard(candidate: candidate, isDark: isDark),
                      Gap(sectionSpacing),
                      CandidateSocialLinksCard(candidate: candidate, isDark: isDark),
                    ],
                  ),
                ),
                Gap(sectionSpacing),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      CandidateQuickActionsCard(isDark: isDark, candidate: candidate),
                      Gap(sectionSpacing),
                      CandidatePersonalInfoCard(candidate: candidate, isDark: isDark),
                      Gap(sectionSpacing),
                      CandidateSourceCard(candidate: candidate, isDark: isDark),
                      Gap(sectionSpacing),
                      CandidateBackgroundCheckCard(candidate: candidate, isDark: isDark),
                    ],
                  ),
                ),
              ],
            )
          : Column(
              children: [
                CandidateContactInfoCard(candidate: candidate, isDark: isDark),
                Gap(sectionSpacing),
                CandidateProfessionalSummaryCard(candidate: candidate, isDark: isDark),
                if (candidate.hasResume) ...[
                  Gap(sectionSpacing),
                  CandidateResumeCard(candidate: candidate, isDark: isDark),
                ],
                Gap(sectionSpacing),
                CandidateCompensationCard(candidate: candidate, isDark: isDark),
                Gap(sectionSpacing),
                CandidateSocialLinksCard(candidate: candidate, isDark: isDark),
                Gap(sectionSpacing),
                CandidatePersonalInfoCard(candidate: candidate, isDark: isDark),
                Gap(sectionSpacing),
                CandidateSourceCard(candidate: candidate, isDark: isDark),
                Gap(sectionSpacing),
                CandidateBackgroundCheckCard(candidate: candidate, isDark: isDark),
                Gap(sectionSpacing),
                CandidateQuickActionsCard(isDark: isDark, candidate: candidate),
              ],
            ),
    );
  }
}
