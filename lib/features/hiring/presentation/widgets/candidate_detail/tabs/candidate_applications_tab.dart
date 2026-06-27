import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/applications/application_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandidateApplicationsTab extends StatelessWidget {
  const CandidateApplicationsTab({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (candidate.applications.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Text(
            'No job applications found for this candidate',
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(24.r),
      child: Column(
        children: candidate.applications.asMap().entries.map((entry) {
          final index = entry.key;
          final application = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index == candidate.applications.length - 1 ? 0 : 16.h),
            child: ApplicationCard(application: application, isDark: isDark),
          );
        }).toList(),
      ),
    );
  }
}
