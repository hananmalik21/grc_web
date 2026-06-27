import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'application_detail_section.dart';

class ApplicationQuickStatsCard extends StatelessWidget {
  const ApplicationQuickStatsCard({required this.detail, super.key});

  final ApplicationDetailData detail;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final daysLabel = detail.daysInPipeline == 1 ? '1 day' : '${detail.daysInPipeline} days';

    return ApplicationDetailSection(
      title: 'Quick Stats',
      child: Column(
        children: [
          _buildStatRow(context, 'Days in pipeline', daysLabel, secondaryText, primaryText),
          Gap(12.h),
          _buildStatRow(context, 'Current stage', detail.currentStage, secondaryText, primaryText),
          Gap(12.h),
          _buildStatRow(context, 'Notes', detail.notesCount.toString(), secondaryText, primaryText),
        ],
      ),
    );
  }

  Widget _buildStatRow(BuildContext context, String label, String value, Color secondaryText, Color primaryText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(color: secondaryText)),
        Text(value, style: context.textTheme.titleSmall?.copyWith(color: primaryText)),
      ],
    );
  }
}
