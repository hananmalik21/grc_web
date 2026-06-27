import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/features/security_manager/presentation/providers/data_roles/data_roles_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';

class DataRoleDetailsDialog extends StatelessWidget {
  const DataRoleDetailsDialog({super.key, required this.role});

  final DataRoleItem role;

  static Future<void> show(BuildContext context, {required DataRoleItem role}) {
    if (context.isMobile) {
      return DigifyBottomSheet.show<void>(
        context,
        type: DigifyBottomSheetType.custom,
        title: role.name,
        child: DataRoleDetailsDialog(role: role),
      );
    }
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => DataRoleDetailsDialog(role: role),
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
            Text(
              'Data Role Details',
              style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
            ),
            Gap(14.h),
            _InfoPair(
              label: 'Role Name',
              value: Text(
                role.name,
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Gap(20.h),
            _InfoPair(
              label: 'Role Code',
              value: Text(
                role.code,
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontFamily: 'Menlo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Gap(20.h),
            _InfoPair(
              label: 'Data Type',
              value: _DataTypeValue(role: role),
            ),
            Gap(20.h),
            _InfoPair(
              label: 'Status',
              value: _StatusValue(isActive: role.isActive),
            ),
            Gap(20.h),
            _InfoPair(
              label: 'Description',
              value: Text(
                role.description,
                style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, height: 1.6),
              ),
            ),
            if (role.createdBy != null) ...[
              Gap(20.h),
              _InfoPair(
                label: 'Created By',
                value: Text(
                  role.createdBy!,
                  style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary),
                ),
              ),
            ],
            Gap(20.h),
            _DataScopeInfoPair(role: role),
            Gap(18.h),
            Row(
              children: [
                Expanded(
                  child: AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop()),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return AppDialog(
      title: 'Data Role Details',
      subtitle: 'View complete data role information',
      width: 620.w,
      onClose: () => Navigator.of(context).pop(),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (context.isMobile) ...[
            _InfoPair(
              label: 'Role Name',
              value: Text(
                role.name,
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Gap(20.h),
            _InfoPair(
              label: 'Role Code',
              value: Text(
                role.code,
                style: context.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontFamily: 'Menlo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Gap(20.h),
            _InfoPair(
              label: 'Data Type',
              value: _DataTypeValue(role: role),
            ),
            Gap(20.h),
            _InfoPair(
              label: 'Status',
              value: _StatusValue(isActive: role.isActive),
            ),
          ] else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoPair(
                    label: 'Role Name',
                    value: Text(
                      role.name,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Gap(20.w),
                Expanded(
                  child: _InfoPair(
                    label: 'Role Code',
                    value: Text(
                      role.code,
                      style: context.textTheme.titleMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontFamily: 'Menlo',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (!context.isMobile) ...[
            Gap(20.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _InfoPair(
                    label: 'Data Type',
                    value: _DataTypeValue(role: role),
                  ),
                ),
                Gap(20.w),
                Expanded(
                  child: _InfoPair(
                    label: 'Status',
                    value: _StatusValue(isActive: role.isActive),
                  ),
                ),
              ],
            ),
          ],
          Gap(20.h),
          _InfoPair(
            label: 'Description',
            value: Text(
              role.description,
              style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary, height: 1.6),
            ),
          ),
          if (role.createdBy != null) ...[
            Gap(20.h),
            _InfoPair(
              label: 'Created By',
              value: Text(role.createdBy!, style: context.textTheme.bodyLarge?.copyWith(color: AppColors.textPrimary)),
            ),
          ],
          Gap(20.h),
          _DataScopeInfoPair(role: role),
        ],
      ),
      actions: [
        const Spacer(),
        AppButton.outline(label: 'Close', onPressed: () => Navigator.of(context).pop()),
      ],
    );
  }
}

class _InfoPair extends StatelessWidget {
  const _InfoPair({required this.label, required this.value});

  final String label;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(6.h),
        value,
      ],
    );
  }
}

class _DataScopeInfoPair extends StatelessWidget {
  const _DataScopeInfoPair({required this.role});

  final DataRoleItem role;

  List<(String, List<String>)> get _sections => [
    if (role.orgUnits.isNotEmpty) ('Org Units', role.orgUnits),
    if (role.positions.isNotEmpty) ('Positions', role.positions),
    if (role.grades.isNotEmpty) ('Grades', role.grades),
    if (role.jobFamilies.isNotEmpty) ('Job Families', role.jobFamilies),
    if (role.jobLevels.isNotEmpty) ('Job Levels', role.jobLevels),
  ];

  @override
  Widget build(BuildContext context) {
    final sections = _sections;
    if (sections.isEmpty) {
      return _InfoPair(
        label: 'Data Scope',
        value: Text(
          'No data scope defined',
          style: context.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Scope',
          style: context.textTheme.labelLarge?.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.3,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gap(10.h),
        for (final (label, items) in sections) ...[
          Text(label, style: context.textTheme.labelSmall?.copyWith(color: AppColors.textSecondary)),
          Gap(6.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              for (final item in items)
                DigifyCapsule(
                  label: item,
                  backgroundColor: AppColors.infoBg,
                  borderColor: AppColors.infoBorder,
                  textColor: AppColors.infoText,
                ),
            ],
          ),
          Gap(12.h),
        ],
      ],
    );
  }
}

class _DataTypeValue extends StatelessWidget {
  const _DataTypeValue({required this.role});

  final DataRoleItem role;

  @override
  Widget build(BuildContext context) {
    return Text(
      role.dataType.isNotEmpty ? role.dataType : '—',
      style: context.textTheme.titleMedium?.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
    );
  }
}

class _StatusValue extends StatelessWidget {
  const _StatusValue({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return DigifyStatusCapsule(status: isActive ? 'Active' : 'Inactive');
  }
}
