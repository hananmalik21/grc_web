import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/domain/configs/hiring_config.dart';
import 'package:grc/features/hiring/presentation/models/candidate_data.dart';
import 'package:grc/features/hiring/presentation/widgets/candidate_detail/tabs/communications/communication_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CandidateCommunicationsTab extends StatelessWidget {
  const CandidateCommunicationsTab({super.key, required this.candidate, required this.isDark});

  final CandidateData candidate;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final communications = HiringConfig.buildCandidateCommunications(candidate.name);

    if (communications.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Text(
            'No communications history found for this candidate',
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    final isMobile = context.isMobileLayout;

    return Padding(
      padding: EdgeInsets.all(isMobile ? 16.w : 24.w),
      child: Column(
        children: communications.asMap().entries.map((entry) {
          final index = entry.key;
          final communication = entry.value;
          return Padding(
            padding: EdgeInsets.only(bottom: index == communications.length - 1 ? 0 : 16.h),
            child: CommunicationCard(communication: communication, isDark: isDark),
          );
        }).toList(),
      ),
    );
  }
}
