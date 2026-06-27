import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_avatar.dart';
import 'package:grc/core/widgets/common/digify_status_capsule.dart';
import 'package:grc/features/employee_management/domain/models/employee_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'employees_mobile_list_skeleton.dart';

class EmployeesMobileListView extends StatelessWidget {
  final List<EmployeeListItem> employees;
  final AppLocalizations localizations;
  final bool isDark;
  final bool isLoading;
  final Function(EmployeeListItem) onView;

  const EmployeesMobileListView({
    super.key,
    required this.employees,
    required this.localizations,
    required this.isDark,
    this.isLoading = false,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return EmployeesMobileListSkeleton(isDark: isDark, itemCount: 6);
    }

    final bgColor = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;
    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    // Header row was removed in favor of a tile list layout.

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10.h),
          itemCount: employees.length,
          separatorBuilder: (_, _) => SizedBox(height: 12.h),
          itemBuilder: (context, index) =>
              _EmployeeTile(employee: employees[index], isDark: isDark, onTap: () => onView(employees[index])),
        ),
      ),
    );
  }
}

class _EmployeeTile extends StatelessWidget {
  const _EmployeeTile({required this.employee, required this.isDark, required this.onTap});

  final EmployeeListItem employee;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final subtitleColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final tileBorderColor = isDark ? AppColors.cardBorderDark : AppColors.dashboardCardBorder;
    final tileBg = isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: tileBg,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: tileBorderColor, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppAvatar(image: null, fallbackInitial: employee.fullName, backgroundColor: AppColors.infoBg),
                        Gap(10.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                employee.fullNameDisplay,
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: titleColor,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              Text(
                                employee.employeeNumberDisplay,
                                style: context.textTheme.labelMedium?.copyWith(color: subtitleColor),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Gap(4.w),
                  DigifyStatusCapsule(status: employee.statusDisplay),
                ],
              ),
              Gap(10.h),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  employee.departmentDisplay,
                  style: context.textTheme.labelLarge?.copyWith(color: subtitleColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
