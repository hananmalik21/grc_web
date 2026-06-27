import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/education/candidate_education_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/education/education_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandidateEducationTab extends StatelessWidget {
  const CandidateEducationTab({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (context.isMobileLayout) {
      return CandidateEducationMobile(candidate: candidate, isDark: isDark);
    }

    if (candidate.educations.isEmpty) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: candidate.educations.asMap().entries.map((entry) {
          final index = entry.key;
          final education = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index == candidate.educations.length - 1 ? 0 : 16.h),
            child: EducationCard(education: education, isDark: isDark),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Text(
          'No education data available',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
