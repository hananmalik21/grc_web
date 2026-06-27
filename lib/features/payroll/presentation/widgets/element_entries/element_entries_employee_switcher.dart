import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/payroll/application/element_entries/providers/element_entries_tab_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/workforce_structure/presentation/providers/employee_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ElementEntriesEmployeeSwitcher extends ConsumerWidget {
  const ElementEntriesEmployeeSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final isMobile = context.isMobileLayout;
    final enterpriseId = ref.watch(elementEntriesEnterpriseIdProvider);
    final tabState = ref.watch(elementEntriesTabProvider);
    final isLoadingEmployeeDetails = tabState.isLoadingEmployeeDetails;
    final employeeState = ref.watch(employeeNotifierProvider);

    final labelText = tabState.selectedEmployee == null
        ? loc.payrollElementEntriesSelectEmployee
        : loc.payrollElementEntriesSwitchEmployee;

    final label = Text(
      labelText,
      style: context.textTheme.labelMedium?.copyWith(
        fontSize: 13.sp,
        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
      ),
    );

    final searchField = enterpriseId == null
        ? _EnterpriseRequiredHint(message: loc.selectEnterpriseFirst)
        : _EmployeeSearchFieldWithLoading(
            isLoading: isLoadingEmployeeDetails,
            child: EmployeeSearchField(
              label: labelText,
              showLabel: false,
              enterpriseId: enterpriseId,
              hintText: loc.payrollElementEntriesSearchHint,
              selectedEmployee: _selectedWorkforceEmployee(
                tabState.selectedEmployee?.employeeId,
                employeeState.employees,
              ),
              onEmployeeSelected: (employee) {
                ref.read(elementEntriesTabProvider.notifier).selectFromWorkforceEmployee(employee);
              },
            ),
          );

    if (isMobile) {
      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [label, Gap(8.h), searchField]);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12.h),
          child: label,
        ),
        Gap(12.w),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Expanded(child: searchField)],
          ),
        ),
      ],
    );
  }

  Employee? _selectedWorkforceEmployee(int? employeeId, List<Employee> employees) {
    if (employeeId == null) return null;
    for (final employee in employees) {
      if (employee.id == employeeId) return employee;
    }
    return null;
  }
}

class _EmployeeSearchFieldWithLoading extends StatelessWidget {
  const _EmployeeSearchFieldWithLoading({required this.isLoading, required this.child});

  final bool isLoading;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Stack(
      alignment: Alignment.center,
      children: [
        AbsorbPointer(
          absorbing: isLoading,
          child: Opacity(opacity: isLoading ? 0.65 : 1, child: child),
        ),
        if (isLoading)
          PositionedDirectional(
            end: 12.w,
            top: 0,
            bottom: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: AppLoadingIndicator(
                    type: LoadingType.ring,
                    size: 18.w,
                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _EnterpriseRequiredHint extends StatelessWidget {
  const _EnterpriseRequiredHint({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.grayBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Text(
        message,
        style: context.textTheme.bodyMedium?.copyWith(
          fontSize: 13.sp,
          color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
        ),
      ),
    );
  }
}
