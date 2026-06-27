import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/update_work_schedule_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/view_work_schedule_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/widgets/view_work_schedule_dialog_header.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class ViewWorkScheduleDialog {
  static Future<void> show(BuildContext context, {required WorkSchedule schedule}) {
    if (ResponsiveHelper.isMobile(context)) {
      return ViewWorkScheduleMobileSheet.show(context, schedule: schedule);
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _ViewWorkScheduleDialogContent(schedule: schedule),
    );
  }
}

class _ViewWorkScheduleDialogContent extends ConsumerWidget with WorkSchedulesPermissionMixin {
  final WorkSchedule schedule;

  const _ViewWorkScheduleDialogContent({required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final enterpriseId = ref.read(timeManagementEnterpriseIdProvider);
    final dateFormatter = DateFormat('EEEE, d MMMM yyyy');
    final formattedStartDate = dateFormatter.format(schedule.effectiveStartDate);
    final formattedEndDate = schedule.effectiveEndDate != null
        ? dateFormatter.format(schedule.effectiveEndDate!)
        : 'N/A';
    final formattedCreatedAt = dateFormatter.format(schedule.creationDate);
    final updatedBy = schedule.lastUpdatedBy.isNotEmpty ? schedule.lastUpdatedBy : '---';

    final dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final sortedWeeklyLines = List<WorkScheduleWeeklyLine>.from(schedule.weeklyLines)
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

    return AppDialog(
      title: 'Work Schedule Details',
      width: 800.w,
      onClose: () => context.pop(),
      actions: [
        AppButton.outline(label: 'Close', width: null, onPressed: () => context.pop()),
        if (canUpdateWorkSchedule) ...[
          Gap(8.w),
          AppButton(
            label: 'Edit Shift',
            width: null,
            onPressed: enterpriseId != null
                ? () {
                    context.pop();
                    UpdateWorkScheduleDialog.show(context, enterpriseId, schedule);
                  }
                : null,
            svgPath: Assets.icons.editIcon.path,
            backgroundColor: AppColors.greenButton,
          ),
        ],
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ViewWorkScheduleDialogHeader(
            title: schedule.scheduleNameEn,
            titleArabic: schedule.scheduleNameAr,
            year: schedule.year,
            code: schedule.scheduleCode,
          ),
          DigifyDivider(margin: EdgeInsets.symmetric(vertical: 24.h)),
          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  context,
                  label: 'Work Pattern',
                  value: schedule.workPatternId.toString(),
                  isDark: isDark,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: _buildInfoRow(context, label: 'Effective Start Date', value: formattedStartDate, isDark: isDark),
              ),
              Gap(16.w),
              Expanded(
                child: _buildInfoRow(context, label: 'Effective End Date', value: formattedEndDate, isDark: isDark),
              ),
            ],
          ),
          Gap(24.h),
          _buildStatusRow(context, isDark),
          Gap(24.h),
          _buildWeeklyScheduleCard(context, sortedWeeklyLines, dayNames, isDark),
          Gap(24.h),
          _buildCreatedAtUpdatedByRow(context, formattedCreatedAt, updatedBy, isDark),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, {required String label, required String value, required bool isDark}) {
    final isEmpty = value.isEmpty || value == 'N/A';
    final displayValue = isEmpty ? '---' : value;
    final textColor = isEmpty
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

  Widget _buildCreatedAtUpdatedByRow(BuildContext context, String createdAt, String updatedBy, bool isDark) {
    final isEmptyUpdatedBy = updatedBy.isEmpty || updatedBy == 'N/A';
    final displayUpdatedBy = isEmptyUpdatedBy ? '---' : updatedBy;
    final updatedByTextColor = isEmptyUpdatedBy
        ? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder)
        : (isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          Text(
            'Created Date: ',
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
          Expanded(
            child: Text(
              createdAt,
              style: context.textTheme.titleSmall?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
              ),
            ),
          ),
          Gap(16.w),
          Text(
            'Updated By: ',
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              fontSize: 12.sp,
            ),
          ),
          Expanded(
            child: Text(displayUpdatedBy, style: context.textTheme.titleSmall?.copyWith(color: updatedByTextColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Status',
          style: context.textTheme.labelMedium?.copyWith(fontSize: 13.8.sp, color: AppColors.tableHeaderText),
        ),
        DigifyStatusCapsule(status: schedule.isActive ? 'Active' : 'Inactive'),
      ],
    );
  }

  Widget _buildWeeklyScheduleCard(
    BuildContext context,
    List<WorkScheduleWeeklyLine> weeklyLines,
    List<String> dayNames,
    bool isDark,
  ) {
    final validLines = weeklyLines.where((line) => line.dayOfWeek >= 1 && line.dayOfWeek <= 7).toList()
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Weekly Schedule',
          style: context.textTheme.titleMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(16.h),
        ...validLines.map((line) {
          final dayName = dayNames[line.dayOfWeek - 1];
          final isWorkDay = line.dayType == 'WORK' && line.shift != null;
          final shift = line.shift;
          final shiftName = isWorkDay && shift != null ? shift.shiftNameEn : 'Rest';

          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: _buildDayCard(context, dayName, shiftName, isWorkDay && shift != null, isDark),
          );
        }),
      ],
    );
  }

  Widget _buildDayCard(BuildContext context, String dayName, String shiftName, bool isWorkDay, bool isDark) {
    return Container(
      width: 848.w,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.infoBorder, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(dayName, style: context.textTheme.titleSmall?.copyWith(fontSize: 16.0, color: AppColors.dialogTitle)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              DigifyAsset(assetPath: Assets.icons.clockIcon.path, width: 16, height: 16, color: AppColors.infoText),
              Gap(8.w),
              Text(shiftName, style: context.textTheme.titleSmall?.copyWith(fontSize: 16.0, color: AppColors.infoText)),
            ],
          ),
        ],
      ),
    );
  }
}
