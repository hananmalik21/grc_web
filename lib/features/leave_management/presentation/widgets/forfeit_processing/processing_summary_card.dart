import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/leave_management/domain/models/forfeit_processing_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ProcessingSummaryCard extends StatelessWidget {
  final ForfeitProcessingSummary summary;
  final bool isDark;

  const ProcessingSummaryCard({super.key, required this.summary, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MM/dd/yyyy, hh:mm:ss a');

    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Processing Summary',
            style: context.textTheme.headlineMedium?.copyWith(
              fontSize: 16.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(14.h),
          _buildSummaryRow(
            context,
            'Processing Date & Time',
            dateFormat.format(summary.processingDate),
            isDark: isDark,
          ),
          Gap(11.h),
          _buildSummaryRow(context, 'Processed By', summary.processedBy, isDark: isDark),
          Gap(11.h),
          _buildSummaryRow(
            context,
            'Total Employees Affected',
            summary.totalEmployeesAffected.toString(),
            isDark: isDark,
          ),
          Gap(11.h),
          _buildSummaryRow(
            context,
            'Total Days Forfeited',
            '${summary.totalDaysForfeited.toStringAsFixed(summary.totalDaysForfeited == summary.totalDaysForfeited.toInt() ? 0 : 1)} days',
            isDark: isDark,
            isHighlighted: true,
          ),
          Gap(11.h),
          _buildSummaryRow(context, 'Audit Log Reference', summary.auditLogReference, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    required bool isDark,
    bool isHighlighted = false,
  }) {
    return Container(
      padding: EdgeInsets.all(11.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.securityProfilesBackground,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isHighlighted ? AppColors.error : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
              fontWeight: isHighlighted ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
