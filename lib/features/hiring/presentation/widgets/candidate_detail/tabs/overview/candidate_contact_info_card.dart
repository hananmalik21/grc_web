import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'candidate_section_card.dart';
import 'candidate_info_widgets.dart';

class CandidateContactInfoCard extends StatelessWidget {
  const CandidateContactInfoCard({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final columns = context.responsive<int>(mobile: 1, tablet: 2, desktop: 2);
    final isWide = columns > 1;

    return CandidateSectionCard(
      title: 'Contact Information',
      isDark: isDark,
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: columns,
        childAspectRatio: isWide ? 3.5 : 4.5,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        children: [
          CandidateInfoItem(
            label: 'Primary Email',
            value: candidate.email,
            assetPath: Assets.icons.emailCardIcon.path,
            isDark: isDark,
          ),
          CandidateInfoItem(
            label: 'Alternate Email',
            value: candidate.alternateEmail ?? 'N/A',
            assetPath: Assets.icons.emailCardIcon.path,
            isDark: isDark,
          ),
          CandidateInfoItem(
            label: 'Primary Phone',
            value: candidate.phone,
            assetPath: Assets.icons.contactInfoIcon.path,
            isDark: isDark,
          ),
          CandidateInfoItem(
            label: 'Alternate Phone',
            value: candidate.alternatePhone ?? 'N/A',
            assetPath: Assets.icons.contactInfoIcon.path,
            isDark: isDark,
          ),
          CandidateInfoItem(
            label: 'Current Location',
            value: candidate.location,
            assetPath: Assets.icons.checkCircleGreen.path,
            isDark: isDark,
          ),
          CandidateInfoItem(
            label: 'Preferred Location',
            value: candidate.preferredLocation ?? 'N/A',
            assetPath: Assets.icons.checkCircleGreen.path,
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}
