import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/widgets/create_job_role_shared_widgets.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/inherited_assignment_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CreateJobRoleSelectionItem extends StatelessWidget {
  const CreateJobRoleSelectionItem({
    super.key,
    required this.label,
    required this.isSelected,
    required this.iconPath,
    this.subtitle,
    this.onTap,
    this.isLocked = false,
  });

  final String label;
  final String? subtitle;
  final bool isSelected;
  final String iconPath;
  final VoidCallback? onTap;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    if (isLocked) {
      return InheritedAssignmentListTile(title: label, gapAfterLock: 10.12);
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.infoBgDark.withValues(alpha: 0.18) : AppColors.infoBg)
              : (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.infoBorder : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
        ),
        child: Row(
          children: [
            CreateJobRoleSelectionCheckbox(isSelected: isSelected, onTap: null),
            Gap(10.12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: context.textTheme.bodyLarge?.copyWith(
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (subtitle != null) ...[
                    Gap(2.h),
                    Text(
                      subtitle!,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            DigifyAsset(assetPath: iconPath, width: 18, height: 18, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
