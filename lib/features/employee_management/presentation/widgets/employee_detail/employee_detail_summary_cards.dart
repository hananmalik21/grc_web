import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/features/employee_management/presentation/models/employee_detail_display_data.dart';
import 'package:grc/features/employee_management/presentation/widgets/employee_detail/employee_detail_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

/// Row of summary cards (Service Period, Grade Level, Total Salary, Nationality).
class EmployeeDetailSummaryCards extends StatelessWidget {
  const EmployeeDetailSummaryCards({super.key, required this.displayData, required this.isDark});

  final EmployeeDetailDisplayData displayData;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    if (context.responsiveData.isTablet && context.isPortrait) {
      return _buildGrid();
    }
    return _buildRow();
  }

  Widget _buildRow() {
    return Row(
      children: [
        Expanded(
          child: EmployeeDetailSummaryCard(title: 'Service Period', value: displayData.servicePeriod, isDark: isDark),
        ),
        Gap(16.w),
        Expanded(
          child: EmployeeDetailSummaryCard(title: 'Grade Level', value: displayData.gradeLevel, isDark: isDark),
        ),
        Gap(16.w),
        Expanded(
          child: EmployeeDetailSummaryCard(title: 'Total Salary', value: displayData.totalSalary, isDark: isDark),
        ),
        Gap(16.w),
        Expanded(
          child: EmployeeDetailSummaryCard(title: 'Nationality', value: displayData.nationality, isDark: isDark),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: EmployeeDetailSummaryCard(
                title: 'Service Period',
                value: displayData.servicePeriod,
                isDark: isDark,
              ),
            ),
            Gap(12.w),
            Expanded(
              child: EmployeeDetailSummaryCard(title: 'Grade Level', value: displayData.gradeLevel, isDark: isDark),
            ),
          ],
        ),
        Gap(12.h),
        Row(
          children: [
            Expanded(
              child: EmployeeDetailSummaryCard(title: 'Total Salary', value: displayData.totalSalary, isDark: isDark),
            ),
            Gap(12.w),
            Expanded(
              child: EmployeeDetailSummaryCard(title: 'Nationality', value: displayData.nationality, isDark: isDark),
            ),
          ],
        ),
      ],
    );
  }
}
