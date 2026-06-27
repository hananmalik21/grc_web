import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/extensions/context_extensions.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/feedback/app_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/edit_duty_role_dialog/edit_duty_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/duty_role_details_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/duty_roles/duty_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_action_buttons.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DutyRoleCard extends ConsumerWidget {
  const DutyRoleCard({super.key, required this.role});

  final DutyRoleItem role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dutyRolesProvider);
    final deleteLoading = state.deletingDutyRoleGuid == role.dutyRoleGuid;

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
                    _DutyRoleMainInfo(role: role),
                    Gap(12.h),
                    RolesManagementActionButtons(
                      onEdit: () => EditDutyRoleDialog.show(context, role: role),
                      onView: () => DutyRoleDetailsDialog.show(context, role: role),
                      onCopy: () => _handleCopy(context),
                      onDelete: deleteLoading ? null : () => _handleDelete(context, ref),
                      deleteIsLoading: deleteLoading,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _DutyRoleMainInfo(role: role)),
                    RolesManagementActionButtons(
                      onEdit: () => EditDutyRoleDialog.show(context, role: role),
                      onView: () => DutyRoleDetailsDialog.show(context, role: role),
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
          _IncludedFunctionRolesSection(items: role.includedFunctionRoles),
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
    if (role.dutyRoleGuid.isEmpty) {
      ToastService.error(context, 'This duty role cannot be deleted (missing id).');
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      barrierDismissible: false,
      builder: (dialogContext) {
        return AppConfirmationDialog.delete(
          title: 'Delete Duty Role',
          message: 'Are you sure you want to delete this duty role?',
          itemName: '${role.name} (${role.code})',
          confirmLabel: 'Delete',
          cancelLabel: 'Cancel',
          onConfirm: () => dialogContext.pop(true),
          onCancel: () => dialogContext.pop(false),
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final errorMessage = await ref.read(dutyRolesProvider.notifier).deleteDutyRole(role.dutyRoleGuid);
    if (!context.mounted) return;

    if (errorMessage != null) {
      ToastService.error(context, errorMessage);
      return;
    }

    ToastService.success(context, '${role.name} deleted successfully', title: 'Deleted');
    await ref.read(dutyRolesProvider.notifier).refresh(showLoading: true);
  }
}

class _DutyRoleMainInfo extends StatelessWidget {
  const _DutyRoleMainInfo({required this.role});

  final DutyRoleItem role;

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
            assetPath: Assets.icons.industryIcon.path,
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
                spacing: 8.w,
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
                  if (role.requiresApproval)
                    DigifySquareCapsule(
                      label: 'Approval Required',
                      backgroundColor: AppColors.approvalRequiredBg,
                      textColor: AppColors.approvalRequiredText,
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
                    label: role.category,
                    backgroundColor: role.categoryBackgroundColor ?? AppColors.infoBg,
                    textColor: role.categoryTextColor ?? AppColors.roleActionBlue,
                    borderColor: role.categoryBorderColor ?? AppColors.infoBorder,
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

class _IncludedFunctionRolesSection extends StatelessWidget {
  const _IncludedFunctionRolesSection({required this.items});

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
              color: AppColors.primary,
            ),
            Gap(6.w),
            Text(
              'Included Function Roles (${items.length})',
              style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
        Gap(8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final item in items)
              DigifySquareCapsule(
                label: item,
                backgroundColor: AppColors.infoBg,
                textColor: AppColors.primary,
                borderColor: AppColors.infoBorder,
                borderRadius: BorderRadius.circular(7.r),
              ),
          ],
        ),
      ],
    );
  }
}
