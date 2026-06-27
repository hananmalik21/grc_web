import 'package:grc/features/compensation/domain/models/employees/employee_adjustment_details.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EmployeeInformationSection extends StatelessWidget {
  final Employee? selectedEmployee;
  final EmployeeAdjustmentDetails? employeeDetails;
  final bool isLoadingEmployeeDetails;
  final int enterpriseId;
  final Function(Employee) onEmployeeSelected;
  final bool lockEmployeeSelection;

  const EmployeeInformationSection({
    super.key,
    this.selectedEmployee,
    this.employeeDetails,
    this.isLoadingEmployeeDetails = false,
    required this.enterpriseId,
    required this.onEmployeeSelected,
    this.lockEmployeeSelection = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.inputBorderDark : AppColors.inputBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              DigifyAsset(
                assetPath: Assets.icons.employeeListIcon.path,
                width: 20.w,
                height: 20.w,
                color: AppColors.primary,
              ),
              Gap(8.w),
              Text(
                'Employee Information',
                style: context.textTheme.titleSmall?.copyWith(
                  fontSize: 18.sp,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          Gap(24.h),
          if (!lockEmployeeSelection)
            EmployeeSearchField(
              label: 'SEARCH & SELECT EMPLOYEE',
              isRequired: true,
              selectedEmployee: selectedEmployee,
              enterpriseId: enterpriseId,
              hintText: 'Search employee by name or ID...',
              onEmployeeSelected: onEmployeeSelected,
            )
          else if (selectedEmployee != null) ...[
            Text(
              selectedEmployee!.fullName,
              style: context.textTheme.titleMedium?.copyWith(
                color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
              ),
            ),
            Gap(8.h),
          ],
          if (selectedEmployee != null) ...[
            Gap(16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: isDark ? AppColors.grayBgDark : AppColors.tableHeaderBackground,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
              ),
              child: Wrap(
                spacing: 24.w,
                runSpacing: 16.h,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  _buildInfoItem(context, 'Employee ID', selectedEmployee?.employeeNumber ?? 'N/A', isDark),
                  _buildInfoItem(context, 'Department', selectedEmployee?.departmentName ?? 'N/A', isDark),
                  _buildInfoItem(
                    context,
                    'Current Base Salary',
                    isLoadingEmployeeDetails ? 'Loading...' : (employeeDetails?.formattedBaseSalary ?? 'N/A'),
                    isDark,
                  ),
                  _buildInfoItem(
                    context,
                    'Allowances',
                    isLoadingEmployeeDetails ? 'Loading...' : (employeeDetails?.formattedAllowances ?? 'N/A'),
                    isDark,
                  ),
                  _buildInfoItem(
                    context,
                    'Total Compensation',
                    isLoadingEmployeeDetails ? 'Loading...' : (employeeDetails?.formattedTotalCompensation ?? 'N/A'),
                    isDark,
                    valueColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value, bool isDark, {Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.labelSmall?.copyWith(
            fontSize: 12.sp,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
          ),
        ),
        Gap(4.h),
        Text(
          value,
          style: context.textTheme.labelLarge?.copyWith(
            fontSize: 14.sp,
            color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
