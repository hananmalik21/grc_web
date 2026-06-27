import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/hiring/presentation/models/application_detail_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'application_detail_section.dart';

class ApplicationDetailsCard extends StatelessWidget {
  const ApplicationDetailsCard({required this.detail, super.key});

  final ApplicationDetailData detail;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final appliedLabel = detail.appliedDate == null ? '—' : DateFormat.yMMMd().format(detail.appliedDate!);

    return ApplicationDetailSection(
      title: 'Application Details',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(context, 'Application Number', detail.applicationNumber, primaryText, secondaryText),
          Gap(16.h),
          _buildDetailRow(context, 'Application Date', appliedLabel, primaryText, secondaryText),
          Gap(16.h),
          _buildDetailRow(context, 'Source', detail.source, primaryText, secondaryText),
          Gap(16.h),
          _buildDetailRow(context, 'Posting', detail.postingTitle, primaryText, secondaryText),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, Color primaryText, Color secondaryText) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: context.textTheme.bodyMedium?.copyWith(color: secondaryText)),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.bodyLarge?.copyWith(fontSize: 16.sp, color: primaryText),
        ),
      ],
    );
  }
}
