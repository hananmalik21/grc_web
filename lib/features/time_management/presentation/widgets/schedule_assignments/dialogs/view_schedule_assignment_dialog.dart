import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_enterprise_provider.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/edit_schedule_assignment_dialog.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/view_schedule_assignment_mobile_sheet.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/dialogs/widgets/view_schedule_assignment_dialog_header.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ViewScheduleAssignmentDialog extends ConsumerWidget with ScheduleAssignmentsPermissionMixin {
  final ScheduleAssignment assignment;

  const ViewScheduleAssignmentDialog({super.key, required this.assignment});

  static Future<void> show(BuildContext context, ScheduleAssignment assignment) {
    if (ResponsiveHelper.isMobile(context)) {
      return ViewScheduleAssignmentMobileSheet.show(context, assignment);
    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ViewScheduleAssignmentDialog(assignment: assignment),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = context.isDark;
    final enterpriseId = ref.read(timeManagementEnterpriseIdProvider);

    return AppDialog(
      title: 'Schedule Assignment Details',
      width: 768.w,
      onClose: () => context.pop(),
      actions: [
        AppButton.outline(label: 'Close', onPressed: () => context.pop()),
        if (canUpdateScheduleAssignment) ...[
          Gap(8.w),
          AppButton(
            label: 'Edit Assignment',
            onPressed: enterpriseId != null
                ? () {
                    context.pop();
                    EditScheduleAssignmentDialog.show(context, enterpriseId, assignment);
                  }
                : null,
            svgPath: Assets.icons.editIcon.path,
          ),
        ],
      ],
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (assignment.workSchedule != null)
            ViewScheduleAssignmentDialogHeader(
              title: assignment.workSchedule!.scheduleNameEn,
              titleArabic: assignment.workSchedule!.scheduleNameAr.isNotEmpty
                  ? assignment.workSchedule!.scheduleNameAr
                  : null,
              code: assignment.workSchedule!.scheduleCode,
            ),
          if (assignment.workSchedule != null) DigifyDivider(margin: EdgeInsets.symmetric(vertical: 24.h)),
          _buildDetailsSection(context, isDark),
          Gap(24.h),
          _buildInfoBox(context, isDark),
        ],
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDetailCard(
          context,
          isDark,
          label: 'Assigned Schedule',
          value: assignment.workSchedule?.scheduleNameEn ?? 'N/A',
          subtitle: assignment.workSchedule?.scheduleCode ?? 'N/A',
          fullWidth: true,
        ),
        Gap(24.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Effective Start Date',
                value: assignment.formattedStartDate,
              ),
            ),
            Gap(24.w),
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Effective End Date',
                value: assignment.formattedEndDate.isEmpty ? 'N/A' : assignment.formattedEndDate,
              ),
            ),
          ],
        ),
        Gap(24.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Status',
                value: '',
                customWidget: DigifyStatusCapsule(status: assignment.isActive ? 'Active' : 'Inactive'),
              ),
            ),
            Gap(24.w),
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Assignment ID',
                value: 'SA-${assignment.scheduleAssignmentId.toString().padLeft(3, '0')}',
              ),
            ),
          ],
        ),
        Gap(16.h),
        Row(
          children: [
            Expanded(
              child: _buildDetailCard(context, isDark, label: 'Assigned By', value: assignment.assignedByName),
            ),
            Gap(24.w),
            Expanded(
              child: _buildDetailCard(
                context,
                isDark,
                label: 'Assigned Date',
                value: assignment.creationDate.toString().substring(0, 10),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    bool isDark, {
    required String label,
    String? value,
    String? subtitle,
    Widget? customWidget,
    bool fullWidth = false,
  }) {
    final cardWidth = fullWidth ? 720.w : 344.w;
    final cardHeight = fullWidth ? 108.h : 84.h;
    final cardPadding = fullWidth
        ? EdgeInsets.all(16.w)
        : EdgeInsets.only(top: 16.h, right: 16.w, bottom: 20.h, left: 16.w);

    return Container(
      width: cardWidth,
      height: cardHeight,
      padding: cardPadding,
      decoration: BoxDecoration(color: AppColors.tableHeaderBackground, borderRadius: BorderRadius.circular(10.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: context.textTheme.labelMedium?.copyWith(fontSize: 14.0, color: AppColors.tableHeaderText)),
          Gap(4.h),
          if (customWidget != null)
            customWidget
          else ...[
            Text(
              value ?? '',
              style: context.textTheme.titleSmall?.copyWith(fontSize: 17.0, color: AppColors.dialogTitle),
            ),
            if (subtitle != null) ...[
              Gap(4.h),
              Text(subtitle, style: context.textTheme.bodySmall?.copyWith(color: AppColors.tableHeaderText)),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildInfoBox(BuildContext context, bool isDark) {
    final statusText = assignment.isActive ? 'Active Assignment' : 'Inactive Assignment';
    final descriptionText = assignment.isActive
        ? 'This schedule assignment is currently active and will remain in effect until ${assignment.formattedEndDate.isEmpty ? 'indefinitely' : assignment.formattedEndDate}.'
        : 'This schedule assignment is currently inactive.';

    return Container(
      padding: EdgeInsets.all(16.w),
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
            width: 20,
            height: 20,
            color: AppColors.primary,
          ),
          Gap(12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  statusText,
                  style: context.textTheme.titleSmall?.copyWith(fontSize: 15.sp, color: AppColors.infoText),
                ),
                Gap(8.h),
                Text(
                  descriptionText,
                  style: context.textTheme.bodySmall?.copyWith(fontSize: 13.sp, color: AppColors.permissionBadgeText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
