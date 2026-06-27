import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/navigation/root_navigator_key.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/create_job_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/roles_management_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobRoleDetailsDialog extends StatelessWidget with RolesManagementPermissionMixin {
  const JobRoleDetailsDialog({super.key, required this.role});

  final JobRoleItem role;

  static Future<void> show(BuildContext context, {required JobRoleItem role}) {
    if (context.isMobile) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.custom,
        title: role.name,
        child: JobRoleDetailsDialog(role: role),
      );
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => JobRoleDetailsDialog(role: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(20.w, 4.h, 20.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              iconPath: Assets.icons.securityManager.functionalRoles.path,
              title: 'Job Role Overview',
              isDark: context.isDark,
            ),
            Gap(12.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: context.isDark
                    ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.35)
                    : AppColors.cardBackgroundGrey,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: context.isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.description.isEmpty ? 'No description provided.' : role.description,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                      height: 1.5,
                    ),
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
                      if (role.isAutoAssign)
                        DigifySquareCapsule(
                          label: 'Auto-Assign',
                          backgroundColor: AppColors.jobRoleBg,
                          textColor: AppColors.roleActionBlue,
                          borderColor: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(8.r),
                          height: 28.h,
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
              iconPath: Assets.icons.industryIcon.path,
              title: 'Duty Roles (${role.dutyRoles.length})',
              isDark: context.isDark,
            ),
            Gap(10.h),
            _buildMobileRoleWrap(context, role.dutyRoles),
            Gap(16.h),
            _SectionHeader(
              iconPath: Assets.icons.securityManager.functionalRoles.path,
              title: 'Function Roles (${role.functionRoles.length})',
              isDark: context.isDark,
            ),
            Gap(10.h),
            _buildMobileRoleWrap(context, role.functionRoles),
            Gap(16.h),
            _SectionHeader(
              iconPath: Assets.icons.securityManager.dataRoles.path,
              title: 'Data Roles (${role.dataRoles.length})',
              isDark: context.isDark,
            ),
            Gap(10.h),
            _buildMobileRoleWrap(context, role.dataRoles),
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
                            EditJobRoleDialog.show(rootContext, role: role);
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

    return AppDialog(
      title: 'Job Role Details',
      width: 820.w,
      onClose: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Basic Information',
            style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          Gap(14.h),
          context.isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoItem(label: 'Role Name', value: role.name),
                    Gap(14.h),
                    _InfoItem(label: 'Role Code', value: role.code),
                    Gap(14.h),
                    _InfoItem(label: 'Job Title', value: role.jobTitle),
                    Gap(14.h),
                    _InfoItem(label: 'Description', value: role.description),
                    Gap(14.h),
                    _InfoItem(
                      label: 'Status',
                      valueWidget: DigifySquareCapsule(
                        label: role.isActive ? 'Active' : 'Inactive',
                        backgroundColor: role.isActive ? AppColors.successBg : AppColors.grayBg,
                        textColor: role.isActive ? AppColors.roleBadgeSystemText : AppColors.textSecondary,
                        borderRadius: BorderRadius.circular(5.r),
                        height: 25.h,
                      ),
                    ),
                    Gap(14.h),
                    _InfoItem(label: 'Users Assigned', value: _usersCount(role.usersAssignedLabel)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _InfoItem(label: 'Role Name', value: role.name),
                        ),
                        Gap(24.w),
                        Expanded(
                          child: _InfoItem(label: 'Role Code', value: role.code),
                        ),
                      ],
                    ),
                    Gap(14.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _InfoItem(label: 'Job Title', value: role.jobTitle),
                        ),
                      ],
                    ),
                    Gap(14.h),
                    _InfoItem(label: 'Description', value: role.description),
                    Gap(14.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _InfoItem(
                            label: 'Status',
                            valueWidget: DigifySquareCapsule(
                              label: role.isActive ? 'Active' : 'Inactive',
                              backgroundColor: role.isActive ? AppColors.successBg : AppColors.grayBg,
                              textColor: role.isActive ? AppColors.roleBadgeSystemText : AppColors.textSecondary,
                              borderRadius: BorderRadius.circular(5.r),
                              height: 25.h,
                            ),
                          ),
                        ),
                        Gap(24.w),
                        Expanded(
                          child: _InfoItem(label: 'Users Assigned', value: _usersCount(role.usersAssignedLabel)),
                        ),
                      ],
                    ),
                  ],
                ),
          Gap(20.h),
          _LinkedRolesSection(title: 'Duty Roles', iconPath: Assets.icons.industryIcon.path, items: role.dutyRoles),
          Gap(16.h),
          _LinkedRolesSection(
            title: 'Function Roles',
            iconPath: Assets.icons.securityManager.functionalRoles.path,
            items: role.functionRoles,
          ),
          Gap(16.h),
          _LinkedRolesSection(
            title: 'Data Roles',
            iconPath: Assets.icons.securityManager.dataRoles.path,
            items: role.dataRoles,
          ),
        ],
      ),
      actions: [
        const Spacer(),
        AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop()),
        Gap(10.w),
        AppButton.primary(
          label: 'Edit Role',
          onPressed: () {
            ToastService.info(context, 'Edit Job Role dialog is not available yet', title: 'Coming Soon');
          },
          svgPath: Assets.icons.editIconPurple.path,
        ),
      ],
    );
  }

  String _usersCount(String value) {
    return value.split(' ').first;
  }

  Widget _buildMobileRoleWrap(BuildContext context, List<String> items) {
    final isDark = context.isDark;

    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.25) : AppColors.sidebarSearchBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        ),
        child: Text(
          'No items assigned.',
          style: context.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final item in items)
          DigifySquareCapsule(
            label: item,
            backgroundColor: AppColors.infoBg,
            textColor: AppColors.roleActionBlue,
            borderColor: AppColors.infoBorder,
            borderRadius: BorderRadius.circular(7.r),
            height: 30.h,
          ),
      ],
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.role});

  final JobRoleItem role;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final cardBackground = isDark
        ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.3)
        : AppColors.cardBackgroundGrey;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;

    final items = <_InfoGridItemData>[
      _InfoGridItemData(label: 'Role Name', value: role.name),
      _InfoGridItemData(label: 'Role Code', value: role.code),
      _InfoGridItemData(label: 'Job Title', value: role.jobTitle),
      _InfoGridItemData(label: 'Users Assigned', value: _extractUsersCount(role.usersAssignedLabel)),
    ];

    return Wrap(
      spacing: 12.w,
      runSpacing: 12.h,
      children: [
        for (final item in items)
          Container(
            width: (1.sw - 52.w) / 2,
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
                  style: context.textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Gap(4.h),
                Text(
                  item.value,
                  style: context.textTheme.bodyLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoGridItemData {
  const _InfoGridItemData({required this.label, required this.value});

  final String label;
  final String value;
}

String _extractUsersCount(String value) {
  return value.split(' ').first;
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

class _InfoItem extends StatelessWidget {
  const _InfoItem({required this.label, this.value, this.valueWidget});

  final String label;
  final String? value;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        ),
        Gap(4.h),
        valueWidget ?? Text(value ?? '', style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary)),
      ],
    );
  }
}

class _LinkedRolesSection extends StatelessWidget {
  const _LinkedRolesSection({required this.title, required this.iconPath, required this.items});

  final String title;
  final String iconPath;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(assetPath: iconPath, width: 16, height: 16, color: AppColors.primary),
            Gap(6.w),
            Text(
              '$title (${items.length})',
              style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
          ],
        ),
        Gap(10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final item in items)
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
      ],
    );
  }
}
