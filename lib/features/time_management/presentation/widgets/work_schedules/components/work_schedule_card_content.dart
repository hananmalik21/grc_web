import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleCardContent extends StatelessWidget {
  final String workPatternName;
  final String assignmentMode;
  final String effectiveStartDate;
  final String effectiveEndDate;
  final Map<String, String> weeklySchedule;

  const WorkScheduleCardContent({
    super.key,
    required this.workPatternName,
    required this.assignmentMode,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.weeklySchedule,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final spacing = ResponsiveHelper.getCardContentSpacing(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = ResponsiveHelper.isMobile(context);
            if (isMobile) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildInfoRow(context, label: 'Assignment Mode', value: assignmentMode, isDark: isDark),
                  Gap(spacing),
                  _buildInfoRow(context, label: 'Effective Start', value: effectiveStartDate, isDark: isDark),
                  Gap(spacing),
                  _buildInfoRow(context, label: 'Effective End', value: effectiveEndDate, isDark: isDark),
                ],
              );
            }
            return Row(
              children: [
                Expanded(
                  child: _buildInfoRow(context, label: 'Assignment Mode', value: assignmentMode, isDark: isDark),
                ),
                Gap(16.w),
                Expanded(
                  child: _buildInfoRow(context, label: 'Effective Start', value: effectiveStartDate, isDark: isDark),
                ),
                Gap(16.w),
                Expanded(
                  child: _buildInfoRow(context, label: 'Effective End', value: effectiveEndDate, isDark: isDark),
                ),
              ],
            );
          },
        ),
        Gap(16.h),
        _buildWeeklySchedule(context, isDark),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, {required String label, required String value, required bool isDark}) {
    final displayValue = value.isEmpty ? '--' : value;
    final textColor = value.isEmpty
        ? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder)
        : (isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
          Gap(4.h),
          Text(displayValue, style: context.textTheme.titleSmall?.copyWith(color: textColor)),
        ],
      ),
    );
  }

  Widget _buildWeeklySchedule(BuildContext context, bool isDark) {
    final daysOfWeek = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    final isMobile = ResponsiveHelper.isMobile(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Weekly Schedule',
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
          ),
        ),
        Gap(8.h),
        isMobile
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: daysOfWeek.asMap().entries.map((entry) {
                    final day = entry.key;
                    final shiftType = weeklySchedule[entry.value] ?? '--';
                    return Row(
                      children: [
                        _buildDayChip(context, entry.value, shiftType, isDark, isMobile: true),
                        if (day < daysOfWeek.length - 1) Gap(8.w),
                      ],
                    );
                  }).toList(),
                ),
              )
            : Row(
                children: daysOfWeek.asMap().entries.map((entry) {
                  final day = entry.key;
                  final shiftType = weeklySchedule[entry.value] ?? '--';
                  return Expanded(
                    child: Row(
                      children: [
                        Expanded(child: _buildDayChip(context, entry.value, shiftType, isDark)),
                        if (day < daysOfWeek.length - 1) Gap(8.w),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildDayChip(BuildContext context, String day, String shiftType, bool isDark, {bool isMobile = false}) {
    final isEmpty = shiftType == '--';
    final textColor = isEmpty
        ? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder)
        : (isDark ? AppColors.textPrimaryDark : AppColors.infoText);

    return Container(
      padding: EdgeInsets.all(8.w),
      width: isMobile ? null : double.infinity,
      constraints: isMobile ? null : const BoxConstraints(minHeight: 52),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.5) : AppColors.infoBg,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
          Gap(4.h),
          Text(shiftType, style: context.textTheme.labelMedium?.copyWith(color: textColor)),
        ],
      ),
    );
  }
}
