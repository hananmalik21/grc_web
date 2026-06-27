import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_permission_matrix_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../roles_management_common_widgets.dart';
import '../roles_management_surface_card.dart';

class RolesManagementPermissionMatrixMobile extends ConsumerStatefulWidget {
  const RolesManagementPermissionMatrixMobile({super.key, required this.permissions});

  final List<RolePermission> permissions;

  @override
  ConsumerState<RolesManagementPermissionMatrixMobile> createState() => _RolesManagementPermissionMatrixMobileState();
}

class _RolesManagementPermissionMatrixMobileState extends ConsumerState<RolesManagementPermissionMatrixMobile> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(rolesManagementPermissionMatrixFormProvider.notifier).initialize(widget.permissions);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final formState = ref.watch(rolesManagementPermissionMatrixFormProvider);
    final formNotifier = ref.read(rolesManagementPermissionMatrixFormProvider.notifier);

    final filteredPermissions = widget.permissions.where((permission) {
      if (formState.searchQuery.trim().isEmpty) return true;
      final query = formState.searchQuery.toLowerCase();
      return permission.name.toLowerCase().contains(query) || permission.group.toLowerCase().contains(query);
    }).toList();

    final groupedPermissions = <String, List<RolePermission>>{};
    for (final permission in filteredPermissions) {
      groupedPermissions.putIfAbsent(permission.group, () => []).add(permission);
    }

    return RolesManagementSectionCard(
      title: 'Permission Matrix',
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Text(
          '${widget.permissions.length} total',
          style: context.textTheme.labelSmall?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSearchControls(formNotifier),
          Gap(16.h),
          _buildPresets(isDark, formState, formNotifier),
          Gap(20.h),
          if (groupedPermissions.isEmpty)
            const RolesManagementEmptyBody(message: 'No permissions found.')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: groupedPermissions.length,
              separatorBuilder: (_, _) => Gap(20.h),
              itemBuilder: (context, index) {
                final groupName = groupedPermissions.keys.elementAt(index);
                final groupPermissions = groupedPermissions[groupName]!;
                return _PermissionGroupMobileCard(
                  groupName: groupName,
                  permissions: groupPermissions,
                  formState: formState,
                  formNotifier: formNotifier,
                );
              },
            ),
          Gap(24.h),
          _buildFooter(isDark),
        ],
      ),
    );
  }

  Widget _buildSearchControls(RolesManagementPermissionMatrixFormNotifier formNotifier) {
    return DigifyTextField.search(
      controller: _searchController,
      hintText: 'Search permissions...',
      filled: true,
      fillColor: context.isDark ? AppColors.cardBackgroundGreyDark : AppColors.sidebarSearchBg,
      onChanged: formNotifier.updateSearchQuery,
    );
  }

  Widget _buildPresets(
    bool isDark,
    RolesManagementPermissionMatrixFormState formState,
    RolesManagementPermissionMatrixFormNotifier formNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Presets:',
          style: context.textTheme.labelMedium?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(10.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _PresetChipMobile(
                label: 'Full Access',
                isSelected: formState.selectedPreset == PermissionMatrixPreset.fullAccess,
                onTap: () => formNotifier.applyPreset(PermissionMatrixPreset.fullAccess, widget.permissions),
              ),
              Gap(8.w),
              _PresetChipMobile(
                label: 'Read Only',
                isSelected: formState.selectedPreset == PermissionMatrixPreset.readOnly,
                onTap: () => formNotifier.applyPreset(PermissionMatrixPreset.readOnly, widget.permissions),
              ),
              Gap(8.w),
              _PresetChipMobile(
                label: 'Manager',
                isSelected: formState.selectedPreset == PermissionMatrixPreset.managerAccess,
                onTap: () => formNotifier.applyPreset(PermissionMatrixPreset.managerAccess, widget.permissions),
              ),
              Gap(8.w),
              _PresetChipMobile(
                label: 'None',
                isSelected: formState.selectedPreset == PermissionMatrixPreset.noAccess,
                onTap: () => formNotifier.applyPreset(PermissionMatrixPreset.noAccess, widget.permissions),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(bool isDark) {
    return Column(
      children: [
        const _PermissionWarningMobile(),
        Gap(16.h),
        AppButton.primary(label: 'Save Permission Changes', height: 48.h, width: double.infinity, onPressed: () {}),
      ],
    );
  }
}

class _PresetChipMobile extends StatelessWidget {
  const _PresetChipMobile({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBackgroundDark : Colors.white),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          ),
        ),
        child: Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            color: isSelected ? Colors.white : (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _PermissionGroupMobileCard extends StatelessWidget {
  const _PermissionGroupMobileCard({
    required this.groupName,
    required this.permissions,
    required this.formState,
    required this.formNotifier,
  });

  final String groupName;
  final List<RolePermission> permissions;
  final RolesManagementPermissionMatrixFormState formState;
  final RolesManagementPermissionMatrixFormNotifier formNotifier;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Row(
              children: [
                DigifyAsset(assetPath: _groupIconFor(groupName), width: 18.w, height: 18.w, color: AppColors.primary),
                Gap(10.w),
                Expanded(
                  child: Text(
                    groupName,
                    style: context.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => formNotifier.setGroupSelection(permissions, true),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('All', style: context.textTheme.labelSmall?.copyWith(color: AppColors.primary)),
                ),
                Gap(12.w),
                TextButton(
                  onPressed: () => formNotifier.setGroupSelection(permissions, false),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text('Clear', style: context.textTheme.labelSmall?.copyWith(color: AppColors.deleteIconRed)),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: permissions.length,
            separatorBuilder: (_, _) =>
                Divider(height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
            itemBuilder: (context, index) {
              final permission = permissions[index];
              return _PermissionMobileTile(permission: permission, formState: formState, formNotifier: formNotifier);
            },
          ),
        ],
      ),
    );
  }

  String _groupIconFor(String group) {
    switch (group) {
      case 'Employee Management':
        return Assets.icons.employeesSmallIcon.path;
      case 'Identity and Documents':
        return Assets.icons.registrationCardIcon.path;
      case 'Attendance':
        return Assets.icons.clockIcon.path;
      case 'Security':
        return Assets.icons.lockIcon.path;
      case 'Settings':
        return Assets.icons.settingsIcon.path;
      default:
        return Assets.icons.workforce.chevronRight.path;
    }
  }
}

class _PermissionMobileTile extends StatelessWidget {
  const _PermissionMobileTile({required this.permission, required this.formState, required this.formNotifier});

  final RolePermission permission;
  final RolesManagementPermissionMatrixFormState formState;
  final RolesManagementPermissionMatrixFormNotifier formNotifier;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Padding(
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  permission.name,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ),
              if (permission.isRisky) const RolesManagementRiskChip(),
            ],
          ),
          Gap(12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _PermissionToggleMobile(
                label: 'View',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.view),
                onChanged: (_) => formNotifier.togglePermission(permission.id, PermissionMatrixColumn.view),
              ),
              _PermissionToggleMobile(
                label: 'Create',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.create),
                onChanged: (_) => formNotifier.togglePermission(permission.id, PermissionMatrixColumn.create),
              ),
              _PermissionToggleMobile(
                label: 'Edit',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.edit),
                onChanged: (_) => formNotifier.togglePermission(permission.id, PermissionMatrixColumn.edit),
              ),
              _PermissionToggleMobile(
                label: 'Delete',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.delete),
                onChanged: (_) => formNotifier.togglePermission(permission.id, PermissionMatrixColumn.delete),
              ),
              _PermissionToggleMobile(
                label: 'Approve',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.approve),
                onChanged: (_) => formNotifier.togglePermission(permission.id, PermissionMatrixColumn.approve),
              ),
              _PermissionToggleMobile(
                label: 'Export',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.export),
                onChanged: (_) => formNotifier.togglePermission(permission.id, PermissionMatrixColumn.export),
              ),
              _PermissionToggleMobile(
                label: 'Override',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.overridePermission),
                onChanged: (_) =>
                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.overridePermission),
              ),
              _PermissionToggleMobile(
                label: 'Upload',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.upload),
                onChanged: (_) => formNotifier.togglePermission(permission.id, PermissionMatrixColumn.upload),
              ),
              _PermissionToggleMobile(
                label: 'Download',
                value: formState.isSelected(permission.id, PermissionMatrixColumn.download),
                onChanged: (_) => formNotifier.togglePermission(permission.id, PermissionMatrixColumn.download),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PermissionToggleMobile extends StatelessWidget {
  const _PermissionToggleMobile({required this.label, required this.value, required this.onChanged});

  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: value
              ? AppColors.primary.withValues(alpha: 0.1)
              : (isDark ? AppColors.cardBackgroundDark : Colors.white),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: value ? AppColors.primary : (isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              value ? Icons.check_circle_rounded : Icons.radio_button_off_rounded,
              size: 14.sp,
              color: value ? AppColors.primary : (isDark ? AppColors.textMutedDark : AppColors.textMuted),
            ),
            Gap(6.w),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                fontSize: 11.sp,
                color: value ? AppColors.primary : (isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
                fontWeight: value ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PermissionWarningMobile extends StatelessWidget {
  const _PermissionWarningMobile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18.sp),
          Gap(10.w),
          Expanded(
            child: Text(
              'Risky permissions may expose sensitive data or allow critical operations. Please assign with caution.',
              style: context.textTheme.labelSmall?.copyWith(
                color: context.isDark ? AppColors.textSecondaryDark : AppColors.error,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
