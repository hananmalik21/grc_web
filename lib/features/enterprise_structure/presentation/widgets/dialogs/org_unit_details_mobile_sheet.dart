import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_bottom_sheet.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OrgUnitDetailsMobileSheet extends StatelessWidget {
  final OrgStructureLevel unit;

  const OrgUnitDetailsMobileSheet({super.key, required this.unit});

  static Future<void> show(BuildContext context, OrgStructureLevel unit) {
    return DigifyBottomSheet.show<void>(
      context,
      type: DigifyBottomSheetType.custom,
      title: unit.displayName,
      child: OrgUnitDetailsMobileSheet(unit: unit),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _MobileSection(
            title: localizations.basicInformation,
            isDark: isDark,
            children: [
              _MobileInfoTile(label: 'Component Type', value: unit.levelCode, isDark: isDark),
              _MobileInfoTile(label: 'Code', value: unit.orgUnitCode, isDark: isDark),
              _MobileInfoTile(label: 'Name (English)', value: unit.orgUnitNameEn, isDark: isDark),
              if (unit.orgUnitNameAr.isNotEmpty)
                _MobileInfoTile(label: 'Name (Arabic)', value: unit.orgUnitNameAr, isDark: isDark, isArabic: true),
              _MobileInfoTile(
                label: localizations.status,
                value: unit.isActive ? 'ACTIVE' : 'INACTIVE',
                isDark: isDark,
                isStatus: true,
                isActive: unit.isActive,
              ),
            ],
          ),
          Gap(20.h),
          _MobileSection(
            title: 'Hierarchy & Relationships',
            isDark: isDark,
            children: [
              _MobileInfoTile(
                label: 'Parent Component',
                value: unit.parentName.isNotEmpty ? unit.parentName : 'None',
                isDark: isDark,
              ),
              _MobileInfoTile(
                label: 'Hierarchy Path',
                value: '${unit.parentName.isNotEmpty ? "${unit.parentName} → " : ""}${unit.orgUnitCode}',
                isDark: isDark,
              ),
              _MobileInfoTile(
                label: 'Hierarchy Level',
                value: 'Level ${unit.parentLevel.isNotEmpty ? (int.tryParse(unit.parentLevel) ?? 0) + 1 : 1}',
                isDark: isDark,
              ),
            ],
          ),
          Gap(20.h),
          _MobileSection(
            title: 'Management Information',
            isDark: isDark,
            children: [
              if (unit.managerName.isNotEmpty)
                _MobileInfoTile(label: 'Manager', value: unit.managerName, isDark: isDark),
              if (unit.location.isNotEmpty)
                _MobileInfoTile(label: localizations.location, value: unit.location, isDark: isDark),
            ],
          ),
          Gap(20.h),
          _MobileSection(
            title: 'Audit Trail',
            isDark: isDark,
            children: [
              _MobileInfoTile(label: 'Last Updated Date', value: unit.lastUpdatedDate, isDark: isDark),
              _MobileInfoTile(label: 'Last Updated By', value: 'HR Admin', isDark: isDark),
            ],
          ),
          if (unit.description.isNotEmpty) ...[
            Gap(20.h),
            Text(
              localizations.description,
              style: context.textTheme.titleSmall?.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            Gap(10.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.inputBgDark : AppColors.tableHeaderBackground,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                unit.description,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _MobileSection extends StatelessWidget {
  const _MobileSection({required this.title, required this.isDark, required this.children});

  final String title;
  final bool isDark;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    if (children.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        Gap(10.h),
        ...children,
      ],
    );
  }
}

class _MobileInfoTile extends StatelessWidget {
  const _MobileInfoTile({
    required this.label,
    required this.value,
    required this.isDark,
    this.isArabic = false,
    this.isStatus = false,
    this.isActive = true,
  });

  final String label;
  final String value;
  final bool isDark;
  final bool isArabic;
  final bool isStatus;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final valueColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 0.38.sw,
            child: Text(
              label,
              style: context.textTheme.bodySmall?.copyWith(fontSize: 12.sp, color: labelColor),
            ),
          ),
          Gap(8.w),
          Expanded(
            child: isStatus
                ? DigifyStatusCapsule(status: value)
                : Text(
                    value.isNotEmpty ? value : '—',
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: valueColor,
                    ),
                    textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  ),
          ),
        ],
      ),
    );
  }
}
