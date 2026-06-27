import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/buttons/action_button_widget.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RolesManagementActionButtons extends StatelessWidget with RolesManagementPermissionMixin {
  const RolesManagementActionButtons({
    super.key,
    this.onEdit,
    this.onView,
    this.onCopy,
    this.onDelete,
    this.deleteIsLoading = false,
  });

  final VoidCallback? onEdit;
  final VoidCallback? onView;
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final bool deleteIsLoading;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (canUpdateRole)
          ActionButtonWidget(
            icon: Assets.icons.editIconPurple.path,
            color: AppColors.primary,
            tooltip: 'Edit',
            onTap: onEdit,
            width: 18.w,
            height: 18.w,
          ),
        if (canViewRole) ...[
          Gap(4.w),
          ActionButtonWidget(
            icon: Assets.icons.viewIconBlue.path,
            color: AppColors.primary,
            tooltip: 'View',
            onTap: onView,
            width: 18.w,
            height: 18.w,
          ),
        ],
        Gap(4.w),
        ActionButtonWidget(
          icon: Assets.icons.copyGray.path,
          color: AppColors.textSecondary,
          tooltip: 'Copy',
          onTap: onCopy,
          width: 18.w,
          height: 18.w,
        ),
        if (canDeleteRole) ...[
          Gap(4.w),
          ActionButtonWidget(
            icon: Assets.icons.deleteIconRed.path,
            color: AppColors.error,
            tooltip: 'Delete',
            onTap: onDelete,
            isLoading: deleteIsLoading,
            width: 18.w,
            height: 18.w,
          ),
        ],
      ],
    );
  }
}
