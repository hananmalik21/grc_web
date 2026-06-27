import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:grc/core/widgets/forms/digify_select_field.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_permission_matrix_form_provider.dart';
import 'package:grc/features/security_manager/presentation/providers/roles_management/roles_management_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'roles_management_common_widgets.dart';
import 'roles_management_surface_card.dart';

class RolesManagementPermissionMatrixCard extends ConsumerStatefulWidget {
  const RolesManagementPermissionMatrixCard({super.key, required this.permissions});

  final List<RolePermission> permissions;

  @override
  ConsumerState<RolesManagementPermissionMatrixCard> createState() => _RolesManagementPermissionMatrixCardState();
}

class _RolesManagementPermissionMatrixCardState extends ConsumerState<RolesManagementPermissionMatrixCard> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(rolesManagementPermissionMatrixFormProvider.notifier).initialize(widget.permissions);
      }
    });
  }

  @override
  void didUpdateWidget(covariant RolesManagementPermissionMatrixCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.permissions != widget.permissions) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ref.read(rolesManagementPermissionMatrixFormProvider.notifier).initialize(widget.permissions);
        }
      });
    }
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

    return RolesManagementSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
              border: Border(
                bottom: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
              ),
            ),
            child: context.isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 10.h,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Permission Matrix',
                              style: context.textTheme.titleMedium?.copyWith(
                                color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          _buildPresets(context, isDark, formState, formNotifier),
                        ],
                      ),
                      _buildSearchControls(context, formState, formNotifier),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Permission Matrix',
                            style: context.textTheme.titleMedium?.copyWith(
                              color: isDark ? AppColors.textPrimaryDark : AppColors.dialogTitle,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          _buildPresets(context, isDark, formState, formNotifier),
                        ],
                      ),
                      Gap(12.h),
                      _buildSearchControls(context, formState, formNotifier),
                    ],
                  ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1640.w,
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(4),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(1),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1),
                      5: FlexColumnWidth(1),
                      6: FlexColumnWidth(1),
                      7: FlexColumnWidth(1),
                      8: FlexColumnWidth(1),
                      9: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackgroundGrey,
                          border: Border(
                            bottom: BorderSide(
                              color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                            ),
                          ),
                        ),
                        children: const [
                          _TableHeader(title: 'Module / Permission', alignment: Alignment.centerLeft),
                          _TableHeader(title: 'View'),
                          _TableHeader(title: 'Create'),
                          _TableHeader(title: 'Edit'),
                          _TableHeader(title: 'Delete'),
                          _TableHeader(title: 'Approve'),
                          _TableHeader(title: 'Export'),
                          _TableHeader(title: 'Override'),
                          _TableHeader(title: 'Upload'),
                          _TableHeader(title: 'Download'),
                        ],
                      ),
                      for (final entry in groupedPermissions.entries) ...[
                        TableRow(
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.cardBackgroundGreyDark.withValues(alpha: 0.78)
                                : AppColors.cardBackgroundGrey,
                          ),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                              child: Row(
                                children: [
                                  DigifyAsset(
                                    assetPath: _groupIconFor(entry.key),
                                    width: 16,
                                    height: 16,
                                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                  ),
                                  Gap(8.w),
                                  Expanded(
                                    child: Text(
                                      entry.key,
                                      style: context.textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox.shrink(),
                            const SizedBox.shrink(),
                            const SizedBox.shrink(),
                            const SizedBox.shrink(),
                            const SizedBox.shrink(),
                            const SizedBox.shrink(),
                            const SizedBox.shrink(),
                            const SizedBox.shrink(),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: Alignment.centerRight,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _GroupActionText(
                                        text: 'Select All',
                                        color: AppColors.primary,
                                        onTap: () => formNotifier.setGroupSelection(entry.value, true),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 14.w),
                                        child: SizedBox(
                                          height: 12.h,
                                          child: DigifyVerticalDivider.standard(
                                            width: 1,
                                            thickness: 1,
                                            color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder,
                                          ),
                                        ),
                                      ),
                                      _GroupActionText(
                                        text: 'Clear',
                                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                                        onTap: () => formNotifier.setGroupSelection(entry.value, false),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        for (final permission in entry.value)
                          TableRow(
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: isDark
                                      ? AppColors.cardBorderDark.withValues(alpha: 0.5)
                                      : AppColors.dashboardCardBorder,
                                ),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                                child: Row(
                                  children: [
                                    Text(
                                      permission.name,
                                      style: context.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                                      ),
                                    ),
                                    if (permission.isRisky) ...[Gap(8.w), const RolesManagementRiskChip()],
                                  ],
                                ),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.view),
                                onChanged: (_) =>
                                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.view),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.create),
                                onChanged: (_) =>
                                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.create),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.edit),
                                onChanged: (_) =>
                                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.edit),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.delete),
                                onChanged: (_) =>
                                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.delete),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.approve),
                                onChanged: (_) =>
                                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.approve),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.export),
                                onChanged: (_) =>
                                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.export),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.overridePermission),
                                onChanged: (_) => formNotifier.togglePermission(
                                  permission.id,
                                  PermissionMatrixColumn.overridePermission,
                                ),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.upload),
                                onChanged: (_) =>
                                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.upload),
                              ),
                              RolesManagementPermissionCell(
                                value: formState.isSelected(permission.id, PermissionMatrixColumn.download),
                                onChanged: (_) =>
                                    formNotifier.togglePermission(permission.id, PermissionMatrixColumn.download),
                              ),
                            ],
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 14.h),
                child: context.isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12.h,
                        children: [
                          const _PermissionWarning(),
                          AppButton.primary(label: 'Save Changes', height: 36.h, onPressed: () {}),
                        ],
                      )
                    : Row(
                        children: [
                          const Expanded(child: _PermissionWarning()),
                          Gap(12.w),
                          AppButton.primary(label: 'Save Changes', height: 34.h, onPressed: () {}),
                        ],
                      ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresets(
    BuildContext context,
    bool isDark,
    RolesManagementPermissionMatrixFormState formState,
    RolesManagementPermissionMatrixFormNotifier formNotifier,
  ) {
    final presetRow = Wrap(
      alignment: WrapAlignment.end,
      runAlignment: WrapAlignment.end,
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        RolesManagementPresetChip(
          label: PermissionMatrixPreset.fullAccess.label,
          isSelected: formState.selectedPreset == PermissionMatrixPreset.fullAccess,
          onTap: () => formNotifier.applyPreset(PermissionMatrixPreset.fullAccess, widget.permissions),
        ),
        RolesManagementPresetChip(
          label: PermissionMatrixPreset.readOnly.label,
          isSelected: formState.selectedPreset == PermissionMatrixPreset.readOnly,
          onTap: () => formNotifier.applyPreset(PermissionMatrixPreset.readOnly, widget.permissions),
        ),
        RolesManagementPresetChip(
          label: PermissionMatrixPreset.managerAccess.label,
          isSelected: formState.selectedPreset == PermissionMatrixPreset.managerAccess,
          onTap: () => formNotifier.applyPreset(PermissionMatrixPreset.managerAccess, widget.permissions),
        ),
        RolesManagementPresetChip(
          label: PermissionMatrixPreset.noAccess.label,
          isSelected: formState.selectedPreset == PermissionMatrixPreset.noAccess,
          onTap: () => formNotifier.applyPreset(PermissionMatrixPreset.noAccess, widget.permissions),
        ),
      ],
    );

    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Presets:',
            style: context.textTheme.titleSmall?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
            ),
          ),
          Gap(8.h),
          presetRow,
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Quick Presets:',
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.tableHeaderText,
          ),
        ),
        Gap(8.w),
        presetRow,
      ],
    );
  }

  Widget _buildSearchControls(
    BuildContext context,
    RolesManagementPermissionMatrixFormState formState,
    RolesManagementPermissionMatrixFormNotifier formNotifier,
  ) {
    if (context.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          DigifyTextField.search(
            controller: _searchController,
            hintText: 'Search permissions...',
            filled: true,
            fillColor: Colors.transparent,
            onChanged: formNotifier.updateSearchQuery,
          ),
          Row(
            children: [
              RolesManagementFieldLabel(text: 'Scope:'),
              Gap(12.w),
              Expanded(
                child: DigifySelectField<String>(
                  value: formState.scope,
                  items: const ['All Employees'],
                  itemLabelBuilder: (item) => item,
                  onChanged: (value) => formNotifier.updateScope(value ?? 'All Employees'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: DigifyTextField.search(
            controller: _searchController,
            hintText: 'Search permissions...',
            filled: true,
            fillColor: Colors.transparent,
            onChanged: formNotifier.updateSearchQuery,
          ),
        ),
        Gap(14.w),
        Row(
          children: [
            RolesManagementFieldLabel(text: 'Scope:'),
            Gap(12.w),
            SizedBox(
              width: 210.w,
              child: DigifySelectField<String>(
                value: formState.scope,
                items: const ['All Employees'],
                itemLabelBuilder: (item) => item,
                onChanged: (value) => formNotifier.updateScope(value ?? 'All Employees'),
              ),
            ),
          ],
        ),
      ],
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

class _PermissionWarning extends StatelessWidget {
  const _PermissionWarning();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DigifyAsset(
          assetPath: Assets.icons.securityManager.securityAlerts.path,
          width: 16,
          height: 16,
          color: AppColors.error,
        ),
        Gap(8.w),
        Expanded(
          child: RichText(
            textAlign: TextAlign.left,
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Risky permissions',
                  style: context.textTheme.labelLarge?.copyWith(
                    fontSize: 12.sp,
                    color: context.isDark ? AppColors.textSecondaryDark : AppColors.error,
                  ),
                ),
                TextSpan(
                  text: ' may expose sensitive data or allow critical operations.',
                  style: context.textTheme.labelSmall?.copyWith(
                    fontSize: 12.sp,
                    color: context.isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.title, this.alignment = Alignment.center});

  final String title;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 21.h),
      alignment: alignment,
      child: Text(
        title,
        style: context.textTheme.headlineMedium?.copyWith(
          fontSize: 14.sp,
          color: context.isDark ? AppColors.textSecondaryDark : AppColors.textDarkSlate,
        ),
      ),
    );
  }
}

class _GroupActionText extends StatelessWidget {
  const _GroupActionText({required this.text, required this.color, required this.onTap});

  final String text;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        style: context.textTheme.labelSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
