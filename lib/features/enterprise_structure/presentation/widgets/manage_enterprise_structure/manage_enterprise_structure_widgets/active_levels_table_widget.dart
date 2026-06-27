import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/data/custom_table.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget for displaying active levels data in a table
class ActiveLevelsTableWidget extends StatelessWidget {
  final List<OrgStructureLevel> levels;
  final bool isLoading;
  final bool isDark;
  final AppLocalizations localizations;

  const ActiveLevelsTableWidget({
    super.key,
    required this.levels,
    required this.isLoading,
    required this.isDark,
    required this.localizations,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && levels.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(40.h),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (levels.isEmpty) {
      return Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
          child: Text(
            localizations.noResultsFound,
            style: TextStyle(fontSize: 14.sp, color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary),
          ),
        ),
      );
    }

    final tableData = levels.map((level) {
      return {
        'org_unit_id': level.orgUnitId,
        'org_structure_id': level.orgStructureName ?? level.orgStructureId.toString(),
        'enterprise_id': level.enterpriseId.toString(),
        'level_code': level.levelCode,
        'org_unit_code': level.orgUnitCode,
        'org_unit_name_en': level.orgUnitNameEn,
        'org_unit_name_ar': level.orgUnitNameAr,
        'parentId': level.parentOrgUnitId ?? '',
        'is_active': level.isActive ? 'Y' : 'N',
        'manager_name': level.managerName,
        'manager_email': level.managerEmail,
        'manager_phone': level.managerPhone,
        'location': level.location,
        'city': level.city,
        'address': level.address,
        'description': level.description,
      };
    }).toList();

    final columns = [
      TableColumn(key: 'org_unit_id', label: 'Org Unit ID', width: 120.w),
      TableColumn(key: 'org_structure_id', label: 'Org Structure', width: 140.w),
      TableColumn(key: 'enterprise_id', label: 'Enterprise ID', width: 120.w),
      TableColumn(key: 'level_code', label: 'Level Code', width: 120.w),
      TableColumn(key: 'org_unit_code', label: 'Org Unit Code', width: 140.w),
      TableColumn(key: 'org_unit_name_en', label: 'Name (EN)', width: 180.w),
      TableColumn(key: 'org_unit_name_ar', label: 'Name (AR)', width: 180.w),
      TableColumn(key: 'parentId', label: 'Parent ID', width: 120.w),
      TableColumn(
        key: 'is_active',
        label: 'Active',
        width: 80.w,
        cellBuilder: (value, rowData) {
          final isActive = value.toString().toUpperCase() == 'Y';
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isActive
                  ? (isDark ? AppColors.success.withValues(alpha: 0.2) : AppColors.successBg)
                  : (isDark ? AppColors.error.withValues(alpha: 0.2) : const Color(0xFFFEE2E2)),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              isActive ? 'Y' : 'N',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: isActive
                    ? (isDark ? AppColors.success : AppColors.successText)
                    : (isDark ? AppColors.error : const Color(0xFF991B1B)),
              ),
            ),
          );
        },
      ),
      TableColumn(key: 'manager_name', label: 'Manager', width: 150.w),
      TableColumn(key: 'manager_email', label: 'Manager Email', width: 200.w),
      TableColumn(key: 'manager_phone', label: 'Manager Phone', width: 150.w),
      TableColumn(key: 'location', label: 'Location', width: 150.w),
      TableColumn(key: 'city', label: 'City', width: 120.w),
      TableColumn(key: 'address', label: 'Address', width: 200.w),
      TableColumn(key: 'description', label: 'Description', width: 250.w),
    ];

    return Container(
      constraints: BoxConstraints(minHeight: 400.h, maxHeight: 600.h),
      child: CustomTable(
        columns: columns,
        data: tableData,
        isLoading: isLoading,
        showHeader: true,
        headerBackgroundColor: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
        rowBackgroundColor: isDark ? AppColors.cardBackgroundDark : Colors.white,
      ),
    );
  }
}
