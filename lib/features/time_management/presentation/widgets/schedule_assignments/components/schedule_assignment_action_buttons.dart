import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/features/time_management/presentation/widgets/schedule_assignments/schedule_assignments_permission_mixin.dart';
import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScheduleAssignmentActionButtons extends StatelessWidget with ScheduleAssignmentsPermissionMixin {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ScheduleAssignmentActionButtons({super.key, this.onView, this.onEdit, this.onDelete, this.isDeleting = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onView != null && canViewScheduleAssignment)
          ActionButtonWidget(
            type: ActionButtonType.view,
            onTap: onView,
            width: 18.w,
            height: 18.w,
            padding: 6.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
        if (onEdit != null && canUpdateScheduleAssignment) ...[
          Gap(8.w),
          ActionButtonWidget(
            type: ActionButtonType.edit,
            onTap: onEdit,
            width: 18.w,
            height: 18.w,
            padding: 6.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
        ],
        if (onDelete != null && canDeleteScheduleAssignment) ...[
          Gap(8.w),
          ActionButtonWidget(
            type: ActionButtonType.delete,
            onTap: onDelete,
            isLoading: isDeleting,
            width: 18.w,
            height: 18.w,
            padding: 6.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
        ],
      ],
    );
  }
}
