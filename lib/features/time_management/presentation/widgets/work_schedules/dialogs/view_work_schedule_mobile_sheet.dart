import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/update_work_schedule_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class ViewWorkScheduleMobileSheet extends ConsumerWidget with WorkSchedulesPermissionMixin {
  final WorkSchedule schedule;

  const ViewWorkScheduleMobileSheet({super.key, required this.schedule});

  static Future<void> show(BuildContext context, {required WorkSchedule schedule}) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Work Schedule Details',
      child: ViewWorkScheduleMobileSheet(schedule: schedule),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final enterpriseId = ref.read(timeManagementEnterpriseIdProvider);
    final dateFormatter = DateFormat('d MMM yyyy');
    final formattedStart = dateFormatter.format(schedule.effectiveStartDate);
    final formattedEnd = schedule.effectiveEndDate != null ? dateFormatter.format(schedule.effectiveEndDate!) : 'N/A';
    final formattedCreated = dateFormatter.format(schedule.creationDate);
    final updatedBy = schedule.lastUpdatedBy.isNotEmpty ? schedule.lastUpdatedBy : '---';

    final dayNames = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    final sortedLines = List<WorkScheduleWeeklyLine>.from(schedule.weeklyLines)
      ..sort((a, b) => a.dayOfWeek.compareTo(b.dayOfWeek));
    final validLines = sortedLines.where((l) => l.dayOfWeek >= 1 && l.dayOfWeek <= 7).toList();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SheetHeader(schedule: schedule, isDark: isDark),
                DigifyDivider(margin: EdgeInsets.symmetric(vertical: 16.h)),
                _InfoGrid(
                  formattedStart: formattedStart,
                  formattedEnd: formattedEnd,
                  formattedCreated: formattedCreated,
                  updatedBy: updatedBy,
                  isActive: schedule.isActive,
                  isDark: isDark,
                ),
                Gap(16.h),
                _WeeklyLines(validLines: validLines, dayNames: dayNames, isDark: isDark),
              ],
            ),
          ),
        ),
        if (canUpdateWorkSchedule)
          _ViewSheetFooter(
            onEdit: () {
              Navigator.of(context).pop();
              if (enterpriseId != null) {
                UpdateWorkScheduleMobileSheet.show(context, enterpriseId, schedule);
              }
            },
          )
        else
          _CloseFooter(),
      ],
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final WorkSchedule schedule;
  final bool isDark;

  const _SheetHeader({required this.schedule, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(10.r)),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.sidebar.workSchedules.path,
            width: 26,
            height: 26,
            color: AppColors.primary,
          ),
        ),
        Gap(12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                schedule.scheduleNameEn,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (schedule.scheduleNameAr.isNotEmpty) ...[
                Gap(2.h),
                Text(
                  schedule.scheduleNameAr,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
              Gap(6.h),
              DigifySquareCapsule(
                label: schedule.scheduleCode.toUpperCase(),
                backgroundColor: AppColors.jobRoleBg,
                textColor: AppColors.infoText,
              ),
            ],
          ),
        ),
        DigifyStatusCapsule(status: schedule.isActive ? 'Active' : 'Inactive'),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final String formattedStart;
  final String formattedEnd;
  final String formattedCreated;
  final String updatedBy;
  final bool isActive;
  final bool isDark;

  const _InfoGrid({
    required this.formattedStart,
    required this.formattedEnd,
    required this.formattedCreated,
    required this.updatedBy,
    required this.isActive,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoTile(label: 'Start Date', value: formattedStart, isDark: isDark),
            ),
            Gap(10.w),
            Expanded(
              child: _InfoTile(label: 'End Date', value: formattedEnd, isDark: isDark),
            ),
          ],
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(
              child: _InfoTile(label: 'Created Date', value: formattedCreated, isDark: isDark),
            ),
            Gap(10.w),
            Expanded(
              child: _InfoTile(label: 'Updated By', value: updatedBy, isDark: isDark),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;

  const _InfoTile({required this.label, required this.value, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final isEmpty = value.isEmpty || value == 'N/A' || value == '---';
    final textColor = isEmpty
        ? (isDark ? AppColors.textPlaceholderDark : AppColors.textPlaceholder)
        : (isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle);

    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(3.h),
          Text(
            isEmpty ? '---' : value,
            style: context.textTheme.labelMedium?.copyWith(color: textColor, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _WeeklyLines extends StatelessWidget {
  final List<WorkScheduleWeeklyLine> validLines;
  final List<String> dayNames;
  final bool isDark;

  const _WeeklyLines({required this.validLines, required this.dayNames, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Schedule',
          style: context.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(10.h),
        ...validLines.map((line) {
          final dayName = dayNames[line.dayOfWeek - 1];
          final isWorkDay = line.dayType == 'WORK' && line.shift != null;
          final shiftName = isWorkDay && line.shift != null ? line.shift!.shiftNameEn : 'Rest';

          return Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.infoBg,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.infoBorder),
              ),
              child: Row(
                children: [
                  Text(
                    dayName,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  DigifyAsset(assetPath: Assets.icons.clockIcon.path, width: 14, height: 14, color: AppColors.infoText),
                  Gap(6.w),
                  Text(shiftName, style: context.textTheme.labelMedium?.copyWith(color: AppColors.infoText)),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ViewSheetFooter extends StatelessWidget {
  final VoidCallback onEdit;

  const _ViewSheetFooter({required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: Row(
            children: [
              AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop(), height: 46),
              Gap(10.w),
              Expanded(
                child: AppButton(
                  label: 'Edit Schedule',
                  svgPath: Assets.icons.editIcon.path,
                  onPressed: onEdit,
                  backgroundColor: AppColors.greenButton,
                  height: 46,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CloseFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DigifyDivider.horizontal(),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 12.h, 16.w, 14.h),
          child: SizedBox(
            width: double.infinity,
            child: AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop(), height: 46),
          ),
        ),
      ],
    );
  }
}
