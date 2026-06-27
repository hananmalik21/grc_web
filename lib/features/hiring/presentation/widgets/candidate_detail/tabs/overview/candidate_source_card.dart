import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'candidate_section_card.dart';
import 'candidate_info_widgets.dart';

class CandidateSourceCard extends StatelessWidget {
  const CandidateSourceCard({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return CandidateSectionCard(
      title: 'Source',
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CandidateSimpleInfoItem(label: 'Sourced From', value: candidate.sourcedFrom ?? 'N/A', isDark: isDark),
          Gap(12.h),
          CandidateSimpleInfoItem(label: 'First Contact', value: candidate.firstContactDate ?? 'N/A', isDark: isDark),
        ],
      ),
    );
  }
}
