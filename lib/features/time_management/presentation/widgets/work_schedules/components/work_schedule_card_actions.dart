import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/action_button.dart';
import 'package:grc/core/widgets/buttons/icon_action_button.dart';
import 'package:grc/features/time_management/presentation/widgets/work_schedules/work_schedules_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class WorkScheduleCardActions extends StatelessWidget with WorkSchedulesPermissionMixin {
  final VoidCallback onViewDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool isDeleting;

  const WorkScheduleCardActions({
    super.key,
    required this.onViewDetails,
    required this.onEdit,
    required this.onDelete,
    this.isDeleting = false,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Row(
      children: [
        if (canViewWorkSchedule)
          Expanded(
            child: ActionButton(
              label: localizations.view,
              onTap: onViewDetails,
              iconPath: Assets.icons.viewIconBlue.path,
              backgroundColor: AppColors.infoBg,
              foregroundColor: AppColors.primary,
            ),
          ),
        if (canUpdateWorkSchedule) ...[
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
        if (canDeleteWorkSchedule) ...[
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
