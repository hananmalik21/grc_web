import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/duty_role_detail_mobile_sheet.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DutyRoleDetailsDialog extends StatelessWidget {
  const DutyRoleDetailsDialog({super.key, required this.role});

  final DutyRoleItem role;

  static Future<void> show(BuildContext context, {required DutyRoleItem role}) {
    if (context.isMobile) {
      return DutyRoleDetailMobileSheet.show(context, role);
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DutyRoleDetailsDialog(role: role),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: 'Duty Role Details',
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
                    _InfoItem(label: 'Category', value: role.category),
                    Gap(14.h),
                    _InfoItem(
                      label: 'Status',
                      valueWidget: DigifyStatusCapsule(status: role.isActive ? 'ACTIVE' : 'INACTIVE'),
                    ),
                    Gap(14.h),
                    _InfoItem(label: 'Description', value: role.description),
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
                          child: _InfoItem(label: 'Category', value: role.category),
                        ),
                        Gap(24.w),
                        Expanded(
                          child: _InfoItem(
                            label: 'Status',
                            valueWidget: DigifyStatusCapsule(status: role.isActive ? 'ACTIVE' : 'INACTIVE'),
                          ),
                        ),
                      ],
                    ),
                    Gap(14.h),
                    _InfoItem(label: 'Description', value: role.description),
                    Gap(14.h),
                    _InfoItem(label: 'Users Assigned', value: _usersCount(role.usersAssignedLabel)),
                  ],
                ),
          Gap(20.h),
          _FunctionRolesSection(items: role.includedFunctionRoles),
        ],
      ),
      actions: [
        const Spacer(),
        AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop()),
        Gap(10.w),
        AppButton.primary(
          label: 'Edit Role',
          onPressed: () {
            ToastService.info(context, 'Edit Duty Role dialog is not available yet', title: 'Coming Soon');
          },
          svgPath: Assets.icons.editIconPurple.path,
        ),
      ],
    );
  }

  String _usersCount(String value) {
    return value.split(' ').first;
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

class _FunctionRolesSection extends StatelessWidget {
  const _FunctionRolesSection({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DigifyAsset(
              assetPath: Assets.icons.securityManager.functionalRoles.path,
              width: 16,
              height: 16,
              color: AppColors.greenButton,
            ),
            Gap(6.w),
            Text(
              'Function Roles (${items.length})',
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
                borderColor: AppColors.dutyRoleFunctionChipBorder,
                borderRadius: BorderRadius.circular(7.r),
                height: 30.h,
              ),
          ],
        ),
      ],
    );
  }
}
