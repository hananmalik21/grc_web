import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_action_buttons.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FunctionRoleCard extends ConsumerWidget {
  const FunctionRoleCard({super.key, required this.role});

  final FunctionRoleItem role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesState = ref.watch(functionRolesProvider);
    final deleteLoading = rolesState.deletingFunctionRoleGuid == role.functionRoleGuid;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _RoleCardMainInfo(role: role),
                    Gap(12.h),
                    RolesManagementActionButtons(
                      onEdit: () => FunctionRoleFormDialog.showEdit(context, role: role),
                      onCopy: () => _handleCopy(context),
                      onDelete: deleteLoading ? null : () => _handleDelete(context, ref),
                      deleteIsLoading: deleteLoading,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _RoleCardMainInfo(role: role)),
                    RolesManagementActionButtons(
                      onEdit: () => FunctionRoleFormDialog.showEdit(context, role: role),
                      onCopy: () => _handleCopy(context),
                      onDelete: deleteLoading ? null : () => _handleDelete(context, ref),
                      deleteIsLoading: deleteLoading,
                    ),
                  ],
                ),
          DigifyDivider(
            color: AppColors.cardBorder,
            margin: EdgeInsets.symmetric(vertical: 16.h),
          ),
          Text(
            'Included Functions (${role.includedFunctions.length})',
            style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          Gap(10.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final isSingleColumn = context.isMobile || constraints.maxWidth < 700.w;
              final itemWidth = isSingleColumn ? constraints.maxWidth : (constraints.maxWidth - 15.w) / 2;

              return Wrap(
                spacing: 15.w,
                runSpacing: 10.h,
                children: [for (final item in role.includedFunctions) _FunctionBadge(label: item, width: itemWidth)],
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _handleCopy(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: role.code));
    if (!context.mounted) return;
    ToastService.success(context, '${role.code} copied to clipboard', title: 'Copied');
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: 'Delete Function Role',
      message: 'Are you sure you want to delete this function role?',
      itemName: '${role.name} (${role.code})',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirmed != true || !context.mounted) return;

    if (role.functionRoleGuid.isEmpty) {
      ToastService.error(context, 'This role cannot be deleted (missing id).');
      return;
    }

    final ok = await ref.read(functionRolesProvider.notifier).deleteFunctionRole(role.functionRoleGuid);
    if (!context.mounted) return;

    if (ok) {
      ToastService.success(context, '${role.name} deleted successfully', title: 'Deleted');
    } else {
      final message = ref.read(functionRolesProvider).error ?? 'Failed to delete function role';
      ToastService.error(context, message);
    }
  }
}

class _RoleCardMainInfo extends StatelessWidget {
  const _RoleCardMainInfo({required this.role});

  final FunctionRoleItem role;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(color: AppColors.infoBg, borderRadius: BorderRadius.circular(10.r)),
          alignment: Alignment.center,
          child: DigifyAsset(
            assetPath: Assets.icons.securityManager.functionalRoles.path,
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
                    style: context.textTheme.titleSmall?.copyWith(fontSize: 16.sp, color: AppColors.textPrimary),
                  ),
                  if (role.isActive)
                    DigifySquareCapsule(
                      label: 'Active',
                      backgroundColor: AppColors.primary,
                      textColor: AppColors.onPrimary,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                ],
              ),
              Gap(6.h),
              Text(role.description, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              Gap(10.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 8.h,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  DigifySquareCapsule(
                    label: role.code,
                    backgroundColor: AppColors.sidebarSearchBg,
                    textColor: AppColors.textSecondary,
                    borderColor: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  DigifySquareCapsule(
                    label: role.moduleName,
                    backgroundColor: AppColors.infoBg,
                    textColor: AppColors.primary,
                    borderColor: AppColors.infoBorder,
                    borderRadius: BorderRadius.circular(7.r),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DigifyAsset(
                        assetPath: Assets.icons.employeeListIcon.path,
                        width: 15,
                        height: 15,
                        color: AppColors.textSecondary,
                      ),
                      Gap(5.w),
                      Text(
                        role.usersAssignedLabel,
                        style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FunctionBadge extends StatelessWidget {
  const _FunctionBadge({required this.label, required this.width});

  final String label;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      constraints: BoxConstraints(minHeight: 40.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        children: [
          DigifyAsset(assetPath: Assets.icons.checkIconGreen.path, width: 16, height: 16, color: AppColors.primary),
          Gap(7.w),
          Expanded(
            child: Text(label, style: context.textTheme.titleSmall?.copyWith(color: AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}
