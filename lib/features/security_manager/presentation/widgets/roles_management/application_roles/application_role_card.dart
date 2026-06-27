import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/features/security_manager/presentation/providers/application_roles/application_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_action_buttons.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_common_widgets.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ApplicationRoleCard extends StatelessWidget {
  const ApplicationRoleCard({super.key, required this.role, required this.onView});

  final ApplicationRoleItem role;
  final VoidCallback onView;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _RoleMainInfo(role: role)),
              RolesManagementActionButtons(onView: onView),
            ],
          ),
          Gap(12.h),
          Wrap(
            spacing: 20.w,
            runSpacing: 8.h,
            children: [
              RolesManagementMetaLine(iconPath: Assets.icons.usersIcon.path, text: role.usersLabel),
              RolesManagementMetaLine(iconPath: Assets.icons.descriptionIcon.path, text: role.category),
              RolesManagementMetaLine(iconPath: Assets.icons.clockIcon.path, text: 'Updated ${role.updatedAt}'),
              RolesManagementMetaLine(
                iconPath: Assets.icons.filledPositionIcon.path,
                text: 'Created by ${role.createdBy}',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoleMainInfo extends StatelessWidget {
  const _RoleMainInfo({required this.role});

  final ApplicationRoleItem role;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.18) : AppColors.infoBg,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.securityIcon.path,
            width: 20,
            height: 20,
            color: AppColors.primary,
          ),
        ),
        Gap(13.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10.w,
                runSpacing: 6.h,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    role.name,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontSize: 16.sp,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  if (role.isActive)
                    DigifySquareCapsule(
                      label: 'Active',
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(5.r),
                    )
                  else
                    DigifySquareCapsule(
                      label: 'Inactive',
                      backgroundColor: AppColors.cardBorder,
                      textColor: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                ],
              ),
              Gap(6.h),
              Text(
                role.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
              Gap(10.h),
            ],
          ),
        ),
      ],
    );
  }
}
