import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/function_role_form_dialog.dart';
import 'package:grc/features/security_manager/presentation/screens/functional_areas/function_role_detail_mobile_sheet.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/function_roles/function_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_action_buttons.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Compact list row for function roles on small screens (directory only).
class FunctionRoleCardMobile extends ConsumerWidget {
  const FunctionRoleCardMobile({super.key, required this.role});

  final FunctionRoleItem role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final rolesState = ref.watch(functionRolesProvider);
    final deleteLoading = rolesState.deletingFunctionRoleGuid == role.functionRoleGuid;
    final isDark = context.isDark;
    final primaryText = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final secondaryText = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final iconBg = isDark ? AppColors.primary.withValues(alpha: 0.18) : AppColors.infoBg;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10.r)),
                alignment: Alignment.center,
                child: DigifyAsset(
                  assetPath: Assets.icons.securityManager.functionalRoles.path,
                  width: 20,
                  height: 20,
                  color: AppColors.primary,
                ),
              ),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      role.name,
                      style: context.textTheme.titleSmall?.copyWith(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: primaryText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(6.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            '${role.code} · ${role.moduleName}',
                            style: context.textTheme.labelMedium?.copyWith(fontSize: 12.sp, color: secondaryText),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (role.isActive) ...[Gap(8.w), DigifyStatusCapsule(status: l10n.active)],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (role.usersAssignedLabel.isNotEmpty) ...[
            Gap(8.h),
            Row(
              children: [
                DigifyAsset(assetPath: Assets.icons.employeeListIcon.path, width: 14, height: 14, color: secondaryText),
                Gap(6.w),
                Expanded(
                  child: Text(
                    role.usersAssignedLabel,
                    style: context.textTheme.labelSmall?.copyWith(fontSize: 11.sp, color: secondaryText),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          Gap(12.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: RolesManagementActionButtons(
              onEdit: () => FunctionRoleFormDialog.showEdit(context, role: role),
              onView: () => FunctionRoleDetailMobileSheet.show(context, role),
              onCopy: () => _handleCopy(context),
              onDelete: deleteLoading ? null : () => _handleDelete(context, ref),
              deleteIsLoading: deleteLoading,
            ),
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
