import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/common/digify_square_capsule.dart';
import 'package:grc/core/widgets/feedback/delete_confirmation_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/edit_data_role_dialog.dart';
import 'package:grc/features/security_manager/presentation/dialogs/roles_management/data_role_details_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:grc/features/security_manager/presentation/widgets/roles_management/roles_management_action_buttons.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DataRoleCard extends ConsumerWidget {
  const DataRoleCard({super.key, required this.role});

  final DataRoleItem role;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteLoading = ref.watch(dataRolesProvider).deletingDataRoleGuid == role.dataRoleGuid;
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
                    _DataRoleMainInfo(role: role),
                    Gap(12.h),
                    RolesManagementActionButtons(
                      onEdit: () => EditDataRoleDialog.show(context, role: role),
                      onView: () => DataRoleDetailsDialog.show(context, role: role),
                      onCopy: () => _handleCopy(context),
                      onDelete: deleteLoading ? null : () => _handleDelete(context, ref),
                      deleteIsLoading: deleteLoading,
                    ),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _DataRoleMainInfo(role: role)),
                    RolesManagementActionButtons(
                      onEdit: () => EditDataRoleDialog.show(context, role: role),
                      onView: () => DataRoleDetailsDialog.show(context, role: role),
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
          _DataScopeSection(role: role),
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
      title: 'Delete Data Role',
      message: 'Are you sure you want to delete this data role?',
      itemName: '${role.name} (${role.code})',
      confirmText: 'Delete',
      cancelText: 'Cancel',
    );

    if (confirmed != true || !context.mounted) return;

    if (role.dataRoleGuid.isEmpty) {
      ToastService.error(context, 'This role cannot be deleted (missing id).');
      return;
    }

    final notifier = ref.read(dataRolesProvider.notifier);
    final ok = await notifier.deleteDataRole(role.dataRoleGuid);
    if (ok) {
      ToastService.successRoot('${role.name} deleted successfully', title: 'Deleted');
      await notifier.refresh(showLoading: true);
    } else {
      ToastService.errorRoot(ref.read(dataRolesProvider).error ?? 'Failed to delete data role');
    }
  }
}

class _DataRoleMainInfo extends StatelessWidget {
  const _DataRoleMainInfo({required this.role});

  final DataRoleItem role;

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
            assetPath: Assets.icons.focusAreaIcon.path,
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
                    )
                  else
                    DigifySquareCapsule(
                      label: 'Inactive',
                      backgroundColor: AppColors.sidebarSearchBg,
                      textColor: AppColors.textSecondary,
                      borderColor: AppColors.cardBorder,
                      borderRadius: BorderRadius.circular(5.r),
                    ),
                ],
              ),
              if (role.description.isNotEmpty) ...[
                Gap(6.h),
                Text(role.description, style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary)),
              ],
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
                  if (role.dataType.isNotEmpty)
                    DigifySquareCapsule(
                      label: role.dataType,
                      backgroundColor: AppColors.infoBg,
                      textColor: AppColors.primary,
                      borderColor: AppColors.infoBorder,
                      borderRadius: BorderRadius.circular(7.r),
                    ),
                  if (role.createdBy != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DigifyAsset(
                          assetPath: Assets.icons.employeeListIcon.path,
                          width: 14,
                          height: 14,
                          color: AppColors.textSecondary,
                        ),
                        Gap(5.w),
                        Text(
                          role.createdBy!,
                          style: context.textTheme.labelSmall?.copyWith(
                            color: AppColors.textSecondary,
                            fontSize: 12.sp,
                          ),
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

class _DataScopeSection extends StatelessWidget {
  const _DataScopeSection({required this.role});

  final DataRoleItem role;

  @override
  Widget build(BuildContext context) {
    final sections = <_ScopeGroup>[
      if (role.orgUnits.isNotEmpty) _ScopeGroup(label: 'Org Units', items: role.orgUnits),
      if (role.positions.isNotEmpty) _ScopeGroup(label: 'Positions', items: role.positions),
      if (role.grades.isNotEmpty) _ScopeGroup(label: 'Grades', items: role.grades),
      if (role.jobFamilies.isNotEmpty) _ScopeGroup(label: 'Job Families', items: role.jobFamilies),
      if (role.jobLevels.isNotEmpty) _ScopeGroup(label: 'Job Levels', items: role.jobLevels),
    ];

    if (sections.isEmpty) {
      return Text(
        'No data scope defined',
        style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Scope',
          style: context.textTheme.labelLarge?.copyWith(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        Gap(12.h),
        for (final section in sections) ...[_ScopeGroupRow(group: section), if (section != sections.last) Gap(10.h)],
      ],
    );
  }
}

class _ScopeGroup {
  const _ScopeGroup({required this.label, required this.items});

  final String label;
  final List<String> items;

  @override
  bool operator ==(Object other) => other is _ScopeGroup && other.label == label;

  @override
  int get hashCode => label.hashCode;
}

class _ScopeGroupRow extends StatelessWidget {
  const _ScopeGroupRow({required this.group});

  final _ScopeGroup group;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: Text(
            group.label,
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary, fontSize: 12.sp),
          ),
        ),
        Gap(8.w),
        Expanded(
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: group.items.map((item) => _ScopeChip(label: item)).toList(),
          ),
        ),
      ],
    );
  }
}

class _ScopeChip extends StatelessWidget {
  const _ScopeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.sidebarSearchBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAsset(assetPath: Assets.icons.checkIconGreen.path, width: 14, height: 14, color: AppColors.primary),
          Gap(6.w),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(color: AppColors.textPrimary, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
