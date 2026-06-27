import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'candidate_section_card.dart';
import 'candidate_info_widgets.dart';

class CandidateCompensationCard extends StatelessWidget {
  const CandidateCompensationCard({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final isMobile = context.isMobileLayout;

    final content = [
      Expanded(
        flex: isMobile ? 0 : 1,
        child: CandidateSalaryItem(label: 'Current Salary', value: candidate.currentSalary ?? 'N/A', isDark: isDark),
      ),
      Gap(isMobile ? 16.h : 24.w),
      Expanded(
        flex: isMobile ? 0 : 1,
        child: CandidateSalaryItem(label: 'Expected Salary', value: candidate.expectedSalary ?? 'N/A', isDark: isDark),
      ),
    ];

    return CandidateSectionCard(
      title: 'Compensation Expectations',
      isDark: isDark,
      child: isMobile
          ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: content)
          : Row(children: content),
    );
  }
}
