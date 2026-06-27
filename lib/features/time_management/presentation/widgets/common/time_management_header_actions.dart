import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/permissions/perm_keys.dart';
import 'package:grc/core/permissions/permission_service.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/features/time_management/presentation/providers/public_holidays_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/schedule_assignments_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/shifts_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_patterns_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/providers/work_schedules_tab_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/common/time_management_tab_config.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/dialogs/create_shift_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/create_schedule_assignment_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/public_holidays/dialogs/create_holiday_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/dialogs/create_work_pattern_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/dialogs/create_work_schedule_dialog.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TimeManagementHeaderActions {
  static Widget? getTrailingAction(BuildContext context, TimeManagementTab currentTab) {
    switch (currentTab) {
      case TimeManagementTab.shifts:
        return Consumer(
          builder: (context, ref, _) {
            final enterpriseId = ref.watch(shiftsTabEnterpriseIdProvider);
            if (enterpriseId == null) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Upload',
                  onPressed: () {},
                  svgPath: Assets.icons.bulkUploadIconFigma.path,
                  backgroundColor: AppColors.shiftUploadButton,
                ),
                Gap(8.w),
                AppButton(
                  label: 'Export',
                  onPressed: () {},
                  svgPath: Assets.icons.downloadIcon.path,
                  backgroundColor: AppColors.shiftExportButton,
                ),
                if (PermissionService.instance.can(PermKeys.timeManagementShiftsCreate)) ...[
                  Gap(8.w),
                  AppButton.primary(
                    label: 'Create Shift',
                    svgPath: Assets.icons.addDivisionIcon.path,
                    onPressed: () => CreateShiftDialog.show(context, enterpriseId: enterpriseId),
                  ),
                ],
              ],
            );
          },
        );
      case TimeManagementTab.workPatterns:
        return Consumer(
          builder: (context, ref, _) {
            final enterpriseId = ref.watch(workPatternsTabEnterpriseIdProvider);
            if (enterpriseId == null) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Upload',
                  onPressed: () {},
                  svgPath: Assets.icons.bulkUploadIconFigma.path,
                  backgroundColor: AppColors.shiftUploadButton,
                ),
                Gap(8.w),
                AppButton(
                  label: 'Export',
                  onPressed: () {},
                  svgPath: Assets.icons.downloadIcon.path,
                  backgroundColor: AppColors.shiftExportButton,
                ),
                if (PermissionService.instance.can(PermKeys.timeManagementWorkPatternsCreate)) ...[
                  Gap(8.w),
                  AppButton.primary(
                    label: 'Create Work Pattern',
                    svgPath: Assets.icons.addDivisionIcon.path,
                    onPressed: () => CreateWorkPatternDialog.show(context, enterpriseId),
                  ),
                ],
              ],
            );
          },
        );
      case TimeManagementTab.workSchedules:
        return Consumer(
          builder: (context, ref, _) {
            final enterpriseId = ref.watch(workSchedulesTabEnterpriseIdProvider);
            if (enterpriseId == null) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Upload',
                  onPressed: () {},
                  svgPath: Assets.icons.bulkUploadIconFigma.path,
                  backgroundColor: AppColors.shiftUploadButton,
                ),
                Gap(8.w),
                AppButton(
                  label: 'Export',
                  onPressed: () {},
                  svgPath: Assets.icons.downloadIcon.path,
                  backgroundColor: AppColors.shiftExportButton,
                ),
                if (PermissionService.instance.can(PermKeys.timeManagementWorkSchedulesCreate)) ...[
                  Gap(8.w),
                  AppButton.primary(
                    label: 'Create Work Schedule',
                    svgPath: Assets.icons.addDivisionIcon.path,
                    onPressed: () => CreateWorkScheduleDialog.show(context, enterpriseId),
                  ),
                ],
              ],
            );
          },
        );
      case TimeManagementTab.scheduleAssignments:
        return Consumer(
          builder: (context, ref, _) {
            final enterpriseId = ref.watch(scheduleAssignmentsTabEnterpriseIdProvider);
            if (enterpriseId == null) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Upload',
                  onPressed: () {},
                  svgPath: Assets.icons.bulkUploadIconFigma.path,
                  backgroundColor: AppColors.shiftUploadButton,
                ),
                Gap(8.w),
                AppButton(
                  label: 'Export',
                  onPressed: () {},
                  svgPath: Assets.icons.downloadIcon.path,
                  backgroundColor: AppColors.shiftExportButton,
                ),
                if (PermissionService.instance.can(PermKeys.timeManagementScheduleAssignmentsCreate)) ...[
                  Gap(8.w),
                  AppButton.primary(
                    label: 'Assign Schedule',
                    svgPath: Assets.icons.addDivisionIcon.path,
                    onPressed: () => CreateScheduleAssignmentDialog.show(context, enterpriseId),
                  ),
                ],
              ],
            );
          },
        );
      case TimeManagementTab.publicHolidays:
        return Consumer(
          builder: (context, ref, _) {
            final enterpriseId = ref.watch(publicHolidaysTabEnterpriseIdProvider);
            if (enterpriseId == null) return const SizedBox.shrink();
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppButton(
                  label: 'Import',
                  onPressed: () {},
                  svgPath: Assets.icons.bulkUploadIconFigma.path,
                  backgroundColor: AppColors.shiftUploadButton,
                ),
                Gap(8.w),
                AppButton(
                  label: 'Export',
                  onPressed: () {},
                  svgPath: Assets.icons.downloadIcon.path,
                  backgroundColor: AppColors.shiftExportButton,
                ),
                if (PermissionService.instance.can(PermKeys.timeManagementPublicHolidaysCreate)) ...[
                  Gap(8.w),
                  AppButton.primary(
                    label: 'Add Holiday',
                    svgPath: Assets.icons.addDivisionIcon.path,
                    onPressed: () => CreateHolidayDialog.show(context, enterpriseId: enterpriseId),
                  ),
                ],
              ],
            );
          },
        );
      default:
        return null;
    }
  }
}
