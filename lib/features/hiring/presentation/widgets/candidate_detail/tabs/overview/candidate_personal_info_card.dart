import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'candidate_section_card.dart';
import 'candidate_info_widgets.dart';

class CandidatePersonalInfoCard extends StatelessWidget {
  const CandidatePersonalInfoCard({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return CandidateSectionCard(
      title: 'Personal Information',
      isDark: isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CandidateSimpleInfoItem(label: 'Date of Birth', value: candidate.dateOfBirth ?? 'N/A', isDark: isDark),
          Gap(12.h),
          CandidateSimpleInfoItem(label: 'Gender', value: candidate.gender ?? 'N/A', isDark: isDark),
          Gap(12.h),
          CandidateSimpleInfoItem(label: 'Nationality', value: candidate.nationality ?? 'N/A', isDark: isDark),
          Gap(12.h),
          CandidateSimpleInfoItem(label: 'Visa Status', value: candidate.visaStatus ?? 'N/A', isDark: isDark),
        ],
      ),
    );
  }
}
