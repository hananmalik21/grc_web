import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/experience/candidate_experience_mobile.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/experience/experience_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandidateExperienceTab extends StatelessWidget {
  const CandidateExperienceTab({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (context.isMobileLayout) {
      return CandidateExperienceMobile(candidate: candidate, isDark: isDark);
    }

    if (candidate.experiences.isEmpty) {
      return _buildEmptyState(context);
    }

    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: candidate.experiences.asMap().entries.map((entry) {
          final index = entry.key;
          final experience = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index == candidate.experiences.length - 1 ? 0 : 16.h),
            child: ExperienceCard(experience: experience, isDark: isDark),
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
          'No experience data available',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
