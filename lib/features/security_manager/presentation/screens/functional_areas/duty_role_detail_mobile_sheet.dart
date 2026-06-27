import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/date_extensions.dart';
import 'package:grc/core/navigation/root_navigator_key.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/duty_role_form_mobile_sheet.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DutyRoleDetailMobileSheet extends StatelessWidget with RolesManagementPermissionMixin {
  const DutyRoleDetailMobileSheet({super.key, required this.role});

  final DutyRoleItem role;

  static Future<void> show(BuildContext context, DutyRoleItem role) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: role.name,
      child: DutyRoleDetailMobileSheet(role: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 4.h, 20.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionHeader(
            iconPath: Assets.icons.securityManager.functionalRoles.path,
            title: 'Duty Role Overview',
            isDark: isDark,
          ),
          Gap(12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.35) : AppColors.cardBackgroundGrey,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role.description.isEmpty ? 'No description provided.' : role.description,
                  style: context.textTheme.bodyMedium?.copyWith(color: secondaryText, height: 1.5),
                ),
                Gap(14.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    DigifyStatusCapsule(
                      status: role.isActive ? 'Active' : 'Inactive',
                      variant: DigifyStatusCapsuleVariant.rounded,
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                      borderRadius: 10.r,
                    ),
                    if (role.requiresApproval)
                      DigifySquareCapsule(
                        label: 'Approval Required',
                        backgroundColor: AppColors.approvalRequiredBg,
                        textColor: AppColors.approvalRequiredText,
                        borderColor: AppColors.cardBorder,
                        borderRadius: BorderRadius.circular(8.r),
                        height: 28.h,
                      ),
                  ],
                ),
              ],
            ),
          ),
          Gap(16.h),
          _InfoGrid(role: role),
          Gap(16.h),
          _SectionHeader(
            iconPath: Assets.icons.securityManager.functionalRoles.path,
            title: 'Included Function Roles (${role.includedFunctionRoles.length})',
            isDark: isDark,
          ),
          Gap(10.h),
          if (role.includedFunctionRoles.isEmpty)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.25) : AppColors.sidebarSearchBg,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
              ),
              child: Text(
                'No function roles included.',
                style: context.textTheme.bodyMedium?.copyWith(color: secondaryText),
              ),
            )
          else
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final item in role.includedFunctionRoles)
                  DigifySquareCapsule(
                    label: item,
                    backgroundColor: AppColors.infoBg,
                    textColor: AppColors.roleActionBlue,
                    borderColor: AppColors.infoBorder,
                    borderRadius: BorderRadius.circular(7.r),
                    height: 30.h,
                  ),
              ],
            ),
          Gap(18.h),
          Row(
            children: [
              Expanded(
                child: AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop()),
              ),
              if (canUpdateRole) ...[
                Gap(10.w),
                Expanded(
                  child: AppButton.primary(
                    label: 'Edit Role',
                    onPressed: () {
                      Navigator.of(context).pop();
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        final rootContext = rootNavigatorKey.currentContext;
                        if (rootContext != null && rootContext.mounted) {
                          DutyRoleFormMobileSheet.showEdit(rootContext, role: role);
                        }
                      });
                    },
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.iconPath, required this.title, required this.isDark});

  final String iconPath;
  final String title;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Row(
      children: [
        Container(
          width: 30.w,
          height: 30.w,
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.infoBg,
            borderRadius: BorderRadius.circular(9.r),
          ),
          alignment: Alignment.center,
          child: DigifyAsset(assetPath: iconPath, width: 15, height: 15, color: AppColors.primary),
        ),
        Gap(10.w),
        Expanded(
          child: Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700, color: primaryText),
          ),
        ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.role});

  final DutyRoleItem role;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final cardBackground = isDark
        ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.3)
        : AppColors.cardBackgroundGrey;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    final items = <_InfoItemData>[
      _InfoItemData(label: 'Role Code', value: role.code),
      _InfoItemData(label: 'Category', value: role.category),
      _InfoItemData(label: 'Users Assigned', value: role.usersAssignedLabel.isEmpty ? '0' : role.usersAssignedLabel),
      _InfoItemData(label: 'Effective From', value: role.effectiveFrom?.toFormattedDate() ?? 'Not set'),
      _InfoItemData(label: 'Expires On', value: role.expirationDate?.toFormattedDate() ?? 'Not set'),
    ];

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: [
        for (final item in items)
          Container(
            width: (MediaQuery.of(context).size.width - 72.w) / 2,
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: cardBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: context.textTheme.labelSmall?.copyWith(color: secondaryText, fontWeight: FontWeight.w600),
                ),
                Gap(6.h),
                Text(
                  item.value,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoItemData {
  const _InfoItemData({required this.label, required this.value});

  final String label;
  final String value;
}
