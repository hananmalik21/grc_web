import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/feedback/app_dialog.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OrgUnitDetailsDialog extends StatelessWidget {
  final OrgStructureLevel unit;

  const OrgUnitDetailsDialog({super.key, required this.unit});

  static Future<void> show(BuildContext context, OrgStructureLevel unit) {
    return showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.45),
      builder: (dialogContext) => OrgUnitDetailsDialog(unit: unit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return AppDialog(
      title: 'Component Details - ${unit.orgUnitNameEn}',
      width: 700.w,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Section(
            title: localizations.basicInformation,
            isDark: isDark,
            children: [
              _InfoTile(label: 'Component Type', value: unit.levelCode, isDark: isDark),
              _InfoTile(label: 'Code', value: unit.orgUnitCode, isDark: isDark),
              _InfoTile(label: 'Name (English)', value: unit.orgUnitNameEn, isDark: isDark),
              _InfoTile(label: 'Name (Arabic)', value: unit.orgUnitNameAr, isDark: isDark, isArabic: true),
              _InfoTile(
                label: localizations.status,
                value: unit.isActive ? 'ACTIVE' : 'INACTIVE',
                isDark: isDark,
                isStatus: true,
                isActive: unit.isActive,
              ),
            ],
          ),
          Gap(24.h),
          _Section(
            title: 'Hierarchy & Relationships',
            isDark: isDark,
            children: [
              _InfoTile(
                label: 'Parent Component',
                value: unit.parentName.isNotEmpty ? unit.parentName : 'None',
                isDark: isDark,
              ),
              _InfoTile(
                label: 'Hierarchy Path',
                value: '${unit.parentName.isNotEmpty ? "${unit.parentName} → " : ""}${unit.orgUnitCode}',
                isDark: isDark,
              ),
              _InfoTile(
                label: 'Hierarchy Level',
                value: 'Level ${unit.parentLevel.isNotEmpty ? (int.tryParse(unit.parentLevel) ?? 0) + 1 : 1}',
                isDark: isDark,
              ),
            ],
          ),
          Gap(24.h),
          _Section(
            title: 'Management Information',
            isDark: isDark,
            children: [
              _InfoTile(label: 'Manager', value: unit.managerName, isDark: isDark),
              _InfoTile(label: localizations.location, value: unit.location, isDark: isDark),
            ],
          ),
          Gap(24.h),
          _Section(
            title: 'Audit Trail',
            isDark: isDark,
            children: [
              _InfoTile(label: 'Last Updated Date', value: unit.lastUpdatedDate, isDark: isDark),
              _InfoTile(label: 'Last Updated By', value: 'HR Admin', isDark: isDark),
            ],
          ),
          Gap(24.h),
          Text(
            localizations.description,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 16.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(12.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isDark ? AppColors.inputBgDark : AppColors.tableHeaderBackground,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              unit.description.isNotEmpty ? unit.description : 'No description provided',
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final bool isDark;

  const _Section({required this.title, required this.children, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: 16.sp,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(16.h),
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 16.0;
            final isNarrow = constraints.maxWidth < 480;
            final tileWidth = isNarrow ? constraints.maxWidth : (constraints.maxWidth - spacing) / 2;

            return Wrap(
              spacing: spacing,
              runSpacing: 16.h,
              children: children.map((child) {
                return SizedBox(width: tileWidth, child: child);
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final bool isArabic;
  final bool isStatus;
  final bool isActive;

  const _InfoTile({
    required this.label,
    required this.value,
    required this.isDark,
    this.isArabic = false,
    this.isStatus = false,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.inputBgDark : AppColors.tableHeaderBackground,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.textTheme.bodyMedium?.copyWith(
              color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
            ),
          ),
          Gap(4.h),
          if (isStatus)
            DigifyCapsule(
              label: value,
              backgroundColor: isActive
                  ? (isDark ? AppColors.successBgDark : AppColors.successBg)
                  : (isDark ? AppColors.errorBgDark : AppColors.errorBg),
              textColor: isActive
                  ? (isDark ? AppColors.successTextDark : AppColors.successText)
                  : (isDark ? AppColors.errorTextDark : AppColors.errorText),
            )
          else
            Text(
              value,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 16.sp,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
        ],
      ),
    );
  }
}
