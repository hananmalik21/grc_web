import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/action_button.dart';
import 'package:grc/core/widgets/buttons/icon_action_button.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/shifts_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShiftCardActions extends StatelessWidget with ShiftsPermissionMixin {
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onCopy;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const ShiftCardActions({
    super.key,
    required this.onView,
    required this.onEdit,
    required this.onCopy,
    this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        if (canViewShift)
          Expanded(
            child: ActionButton(
              label: localizations.view,
              onTap: onView,
              iconPath: Assets.icons.viewIconBlue.path,
              backgroundColor: AppColors.infoBg,
              foregroundColor: AppColors.primary,
            ),
          ),
        if (canViewShift) ...[
          Gap(8.w),
          Expanded(
            child: ActionButton(
              label: localizations.edit,
              onTap: onEdit,
              iconPath: Assets.icons.editIconGreen.path,
              backgroundColor: AppColors.greenBg,
              foregroundColor: AppColors.greenButton,
            ),
          ),
        ],
        if (onDelete != null && canDeleteShift) ...[
          Gap(8.w),
          IconActionButton(
            iconPath: Assets.icons.deleteIconRed.path,
            bgColor: AppColors.errorBg,
            iconColor: AppColors.error,
            onPressed: isDeleting ? null : onDelete,
            isLoading: isDeleting,
          ),
        ],
      ],
    );
  }
}
