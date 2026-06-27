import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/edit_schedule_assignment_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ViewScheduleAssignmentMobileSheet extends ConsumerWidget with ScheduleAssignmentsPermissionMixin {
  final ScheduleAssignment assignment;

  const ViewScheduleAssignmentMobileSheet({super.key, required this.assignment});

  static Future<void> show(BuildContext context, ScheduleAssignment assignment) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: 'Schedule Assignment Details',
      child: ViewScheduleAssignmentMobileSheet(assignment: assignment),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final enterpriseId = ref.read(timeManagementEnterpriseIdProvider);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SheetHeader(assignment: assignment, isDark: isDark),
                DigifyDivider(margin: EdgeInsets.symmetric(vertical: 16.h)),
                _InfoGrid(assignment: assignment, isDark: isDark),
                if (assignment.notes != null && assignment.notes!.isNotEmpty) ...[
                  Gap(12.h),
                  _NotesSection(notes: assignment.notes!, isDark: isDark),
                ],
                Gap(12.h),
                _InfoBox(assignment: assignment, isDark: isDark),
              ],
            ),
          ),
        ),
        if (canUpdateScheduleAssignment)
          _ViewSheetFooter(
            onEdit: () {
              Navigator.of(context).pop();
              if (enterpriseId != null) {
                EditScheduleAssignmentDialog.show(context, enterpriseId, assignment);
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
  final ScheduleAssignment assignment;
  final bool isDark;

  const _SheetHeader({required this.assignment, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final scheduleName = assignment.workSchedule?.scheduleNameEn ?? 'N/A';
    final scheduleCode = assignment.workSchedule?.scheduleCode ?? '';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48.w,
          height: 48.w,
          decoration: BoxDecoration(color: AppColors.jobRoleBg, borderRadius: BorderRadius.circular(10.r)),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.timeManagement.scheduleAssignment.path,
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
                scheduleName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleSmall?.copyWith(
                  color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gap(4.h),
              Text(
                assignment.assignedToName,
                style: context.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              if (scheduleCode.isNotEmpty) ...[
                Gap(6.h),
                DigifySquareCapsule(
                  label: scheduleCode.toUpperCase(),
                  backgroundColor: AppColors.jobRoleBg,
                  textColor: AppColors.infoText,
                ),
              ],
            ],
          ),
        ),
        DigifyStatusCapsule(status: assignment.isActive ? 'Active' : 'Inactive'),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  final ScheduleAssignment assignment;
  final bool isDark;

  const _InfoGrid({required this.assignment, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final endDate = assignment.formattedEndDate.isEmpty ? 'N/A' : assignment.formattedEndDate;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoTile(label: 'Start Date', value: assignment.formattedStartDate, isDark: isDark),
            ),
            Gap(10.w),
            Expanded(
              child: _InfoTile(label: 'End Date', value: endDate, isDark: isDark),
            ),
          ],
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(
              child: _InfoTile(label: 'Assigned To', value: assignment.assignedToName, isDark: isDark),
            ),
            Gap(10.w),
            Expanded(
              child: _InfoTile(label: 'Assigned By', value: assignment.assignedByName, isDark: isDark),
            ),
          ],
        ),
        Gap(10.h),
        Row(
          children: [
            Expanded(
              child: _InfoTile(
                label: 'Assignment ID',
                value: 'SA-${assignment.scheduleAssignmentId.toString().padLeft(3, '0')}',
                isDark: isDark,
              ),
            ),
            Gap(10.w),
            Expanded(
              child: _InfoTile(
                label: 'Created Date',
                value: assignment.creationDate.toString().substring(0, 10),
                isDark: isDark,
              ),
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

class _NotesSection extends StatelessWidget {
  final String notes;
  final bool isDark;

  const _NotesSection({required this.notes, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes',
            style: context.textTheme.labelSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(4.h),
          Text(
            notes,
            style: context.textTheme.bodySmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final ScheduleAssignment assignment;
  final bool isDark;

  const _InfoBox({required this.assignment, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final statusText = assignment.isActive ? 'Active Assignment' : 'Inactive Assignment';
    final descriptionText = assignment.isActive
        ? 'This schedule assignment is currently active and will remain in effect until ${assignment.formattedEndDate.isEmpty ? 'indefinitely' : assignment.formattedEndDate}.'
        : 'This schedule assignment is currently inactive.';

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : AppColors.infoBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.infoBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.timeManagement.tooltip.path,
            width: 18,
            height: 18,
            color: AppColors.primary,
          ),
          Gap(10.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusText,
                  style: context.textTheme.labelMedium?.copyWith(
                    color: AppColors.infoText,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gap(4.h),
                Text(
                  descriptionText,
                  style: context.textTheme.bodySmall?.copyWith(color: AppColors.permissionBadgeText),
                ),
              ],
            ),
          ),
        ],
      ),
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
                  label: 'Edit Assignment',
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
