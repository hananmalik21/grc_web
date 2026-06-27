import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'candidate_section_card.dart';
import 'candidate_info_widgets.dart';

class CandidateProfessionalSummaryCard extends StatelessWidget {
  const CandidateProfessionalSummaryCard({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive<int>(mobile: 1, tablet: 2, desktop: 2);
    final isWide = columns > 1;

    return CandidateSectionCard(
      title: 'Professional Summary',
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: columns,
        childAspectRatio: isWide ? 3.5 : 4.5,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        children: [
          CandidateInfoItem(label: 'Current Company', value: candidate.company, isDark: isDark),
          CandidateInfoItem(label: 'Current Title', value: candidate.jobTitle, isDark: isDark),
          CandidateInfoItem(label: 'Total Experience', value: candidate.experience, isDark: isDark),
          CandidateInfoItem(
            label: 'Highest Qualification',
            value: candidate.highestQualification ?? 'N/A',
            isDark: isDark,
          ),
          CandidateInfoItem(label: 'Notice Period', value: candidate.noticePeriod ?? 'N/A', isDark: isDark),
          CandidateInfoItem(
            label: 'Willing to Relocate',
            value: candidate.willingToRelocate ? 'Yes' : 'No',
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
