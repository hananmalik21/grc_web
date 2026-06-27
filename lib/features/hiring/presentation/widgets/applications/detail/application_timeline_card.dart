import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_dot.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'application_detail_section.dart';

class ApplicationTimelineCard extends StatelessWidget {
  const ApplicationTimelineCard({required this.detail, super.key});

  final ApplicationDetailData detail;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final entries = detail.stageHistory;

    return ApplicationDetailSection(
      title: 'Activity Timeline',
      child: entries.isEmpty
          ? Text(
              'No activity recorded yet.',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < entries.length; i++) ...[
                  if (i > 0) Gap(16.h),
                  _buildTimelineItem(context, entries[i], isDark),
                ],
              ],
            ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, ApplicationTimelineEntry entry, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DigifyStatusDot(color: AppColors.success, size: 8),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                entry.title,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Text(
                entry.dateLabel,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              if (entry.comments != null && entry.comments!.isNotEmpty) ...[
                Gap(4.h),
                Text(
                  entry.comments!,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
