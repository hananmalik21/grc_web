import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// A single row of label + value for use in [EmployeeDetailSectionCard].
class EmployeeDetailSectionRow {
  const EmployeeDetailSectionRow({required this.label, required this.value});

  final String label;
  final String value;
}

/// Card with a title and a list of label/value rows for employee detail tab content.
class EmployeeDetailSectionCard extends StatelessWidget {
  const EmployeeDetailSectionCard({super.key, required this.title, required this.rows, required this.isDark});

  final String title;
  final List<EmployeeDetailSectionRow> rows;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: textPrimary),
          ),
          Gap(16.h),
          ...rows.map(
            (row) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140.w,
                    child: Text(
                      row.label,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textSecondary),
                    ),
                  ),
                  Expanded(
                    child: Text(row.value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: textPrimary)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
