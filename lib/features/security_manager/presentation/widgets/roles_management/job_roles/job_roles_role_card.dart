import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/create_job_role_dialog/create_job_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/job_role_details_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/job_roles/job_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_action_buttons.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class JobRoleCard extends ConsumerWidget {
  const JobRoleCard({super.key, required this.role});

  final JobRoleItem role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesState = ref.watch(jobRolesProvider);
    final deleteLoading = rolesState.deletingJobRoleGuid == role.jobRoleGuid;
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
                    _JobRoleMainInfo(role: role),
                    Gap(12.h),
                    RolesManagementActionButtons(
                      onEdit: () => _handleEdit(context),
                      onView: () => JobRoleDetailsDialog.show(context, role: role),
                      onCopy: () => _handleCopy(context),
                      onDelete: deleteLoading ? null : () => _handleDelete(context, ref),
                      deleteIsLoading: deleteLoading,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _JobRoleMainInfo(role: role)),
                    RolesManagementActionButtons(
                      onEdit: () => _handleEdit(context),
                      onView: () => JobRoleDetailsDialog.show(context, role: role),
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
          _JobRoleLinkedSection(title: 'Duty Roles', iconPath: Assets.icons.industryIcon.path, items: role.dutyRoles),
          Gap(14.h),
          _JobRoleLinkedSection(
            title: 'Function Roles',
            iconPath: Assets.icons.securityManager.functionalRoles.path,
            items: role.functionRoles,
          ),
          Gap(14.h),
          _JobRoleLinkedSection(
            title: 'Data Roles',
            iconPath: Assets.icons.securityManager.dataRoles.path,
            items: role.dataRoles,
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

  Future<void> _handleEdit(BuildContext context) {
    return EditJobRoleDialog.show(context, role: role);
  }

  Future<void> _handleDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await DeleteConfirmationDialog.show(
      context,
      title: 'Delete Job Role',
      message: 'Are you sure you want to delete this job role?',
      itemName: '${role.name} (${role.code})',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirmed != true || !context.mounted) return;

    if (role.jobRoleGuid.isEmpty) {
      ToastService.error(context, 'This role cannot be deleted (missing id).');
      return;
    }

    final notifier = ref.read(jobRolesProvider.notifier);
    final ok = await notifier.deleteJobRole(role.jobRoleGuid);
    if (ok) {
      ToastService.successRoot('${role.name} deleted successfully', title: 'Deleted');
      await notifier.refresh(showLoading: true);
    } else {
      ToastService.errorRoot(ref.read(jobRolesProvider).error ?? 'Failed to delete job role');
    }
  }
}

class _JobRoleMainInfo extends StatelessWidget {
  const _JobRoleMainInfo({required this.role});

  final JobRoleItem role;

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
            assetPath: Assets.icons.leadershipIcon.path,
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
                  if (role.isAutoAssign)
                    DigifySquareCapsule(
                      label: 'Auto-Assign',
                      backgroundColor: AppColors.jobRoleBg,
                      textColor: AppColors.roleActionBlue,
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
                    label: role.jobTitle,
                    backgroundColor: AppColors.payrollManagerBg,
                    textColor: AppColors.payrollManagerText,
                    borderColor: AppColors.payrollManagerBorder,
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
                  DigifySquareCapsule(
                    label: role.code,
                    backgroundColor: AppColors.sidebarSearchBg,
                    textColor: AppColors.textSecondary,
                    borderColor: AppColors.cardBorder,
                    borderRadius: BorderRadius.circular(5.r),
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

class _JobRoleLinkedSection extends StatelessWidget {
  const _JobRoleLinkedSection({required this.title, required this.iconPath, required this.items});

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
