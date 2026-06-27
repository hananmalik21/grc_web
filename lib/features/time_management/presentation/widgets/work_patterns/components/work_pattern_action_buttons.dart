import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/work_patterns_permission_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkPatternActionButtons extends StatelessWidget with WorkPatternsPermissionMixin {
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  // final VoidCallback? onCopy; // Commented out - not needed for now

  const WorkPatternActionButtons({
    super.key,
    this.onView,
    this.onEdit,
    this.onDelete,
    // this.onCopy, // Commented out - not needed for now
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onView != null && canViewWorkPattern)
          ActionButtonWidget(
            type: ActionButtonType.view,
            onTap: onView,
            width: 18.w,
            height: 18.w,
            padding: 6.w,
            borderRadius: BorderRadius.circular(6.r),
            customBorder: null,
          ),
        if (onEdit != null && canUpdateWorkPattern) ...[
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
        // Copy option - commented out for now
        // if (onCopy != null)
        //   DigifyAssetButton(
        //     assetPath: Assets.icons.copyIcon.path,
        //     onTap: onCopy,
        //     width: 16,
        //     height: 16,
        //   ),
        // if (onCopy != null && onDelete != null) SizedBox(width: 8.w),
        if (onDelete != null && canDeleteWorkPattern) ...[
          Gap(8.w),
          ActionButtonWidget(
            type: ActionButtonType.delete,
            onTap: onDelete,
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
