import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/edit_application_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'roles_management_common_widgets.dart';
import 'roles_management_surface_card.dart';

class RolesManagementSelectedRoleOverviewCard extends StatelessWidget {
  const RolesManagementSelectedRoleOverviewCard({super.key, required this.role, required this.users});

  final RoleModel role;
  final List<RoleAssignedUser> users;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final badgeIsSystem = role.roleBadge.toLowerCase().contains('system');

    return RolesManagementSurfaceCard(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (context.isMobile)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 16.h,
              children: [
                _RoleOverviewHeader(role: role, badgeIsSystem: badgeIsSystem),
                _RoleOverviewActions(role: role),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _RoleOverviewHeader(role: role, badgeIsSystem: badgeIsSystem),
                ),
                Gap(16.w),
                _RoleOverviewActions(role: role),
              ],
            ),
          DigifyDivider(
            color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
            margin: EdgeInsets.only(top: 18.h, bottom: 12.h),
          ),
          Text(
            'Assigned Users',
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textPrimaryDark : AppColors.tableHeaderText,
            ),
          ),
          Gap(10.h),
          SizedBox(
            height: 27.h,
            child: Stack(
              children: [
                for (int index = 0; index < users.take(5).length; index++)
                  Positioned(
                    left: index * 20.w,
                    child: AppAvatar(
                      fallbackInitial: users[index].name,
                      size: 27.w,
                      border: Border.all(
                        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
                        width: 2,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoleOverviewHeader extends StatelessWidget {
  const _RoleOverviewHeader({required this.role, required this.badgeIsSystem});

  final RoleModel role;
  final bool badgeIsSystem;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 15.h,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.w,
          runSpacing: 8.h,
          children: [
            Text(
              role.name,
              style: context.textTheme.titleLarge?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            DigifyCapsule(
              label: role.roleBadge,
              backgroundColor: badgeIsSystem ? AppColors.successBg : AppColors.infoBg,
              textColor: badgeIsSystem ? AppColors.roleBadgeSystemText : AppColors.roleActionBlue,
            ),
          ],
        ),
        Text(
          role.description,
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
        Wrap(
          spacing: 18.w,
          runSpacing: 8.h,
          children: [
            RolesManagementMetaLine(
              iconPath: Assets.icons.employeesBlueIcon.path,
              text: '${role.usersAssigned} users assigned',
            ),
            RolesManagementMetaLine(iconPath: Assets.icons.clockIcon.path, text: role.updatedLabel),
          ],
        ),
      ],
    );
  }
}

class _RoleOverviewActions extends StatelessWidget {
  const _RoleOverviewActions({required this.role});

  final RoleModel role;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      AppButton(
        label: 'Edit Role',
        svgPath: Assets.icons.editIconGreen.path,
        type: AppButtonType.outline,
        backgroundColor: AppColors.infoBg,
        borderColor: AppColors.infoBorder,
        foregroundColor: AppColors.roleActionBlue,
        svgAssetColor: AppColors.roleActionBlue,
        height: 32.h,
        fontSize: 12.sp,
        onPressed: () => EditApplicationRoleDialog.show(context, role: role),
      ),
      AppButton(
        label: 'Clone',
        svgPath: Assets.icons.copyGray.path,
        type: AppButtonType.outline,
        backgroundColor: AppColors.roleCloneBg,
        borderColor: AppColors.cardBorder,
        foregroundColor: AppColors.textDarkSlate,
        svgAssetColor: AppColors.textDarkSlate,
        height: 32.h,
        fontSize: 12.sp,
        onPressed: () async {
          await Clipboard.setData(ClipboardData(text: role.code));
          if (!context.mounted) return;
          ToastService.success(context, '${role.code} copied to clipboard', title: 'Copied');
        },
      ),
    ];

    if (context.isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, spacing: 10.h, children: buttons);
    }

    return Wrap(spacing: 10.w, runSpacing: 10.h, children: buttons);
  }
}
