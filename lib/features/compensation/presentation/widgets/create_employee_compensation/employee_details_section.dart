import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/compensation/presentation/widgets/create_employee_compensation/compensation_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../providers/create_employee_compensation/employee_details_provider.dart';

class EmployeeDetailsSection extends ConsumerWidget {
  final int enterpriseId;

  const EmployeeDetailsSection({super.key, required this.enterpriseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(employeeCompensationDetailsProvider);
    final notifier = ref.read(employeeCompensationDetailsProvider.notifier);

    final isMobile = context.isMobileLayout;

    return CompensationSectionCard(
      title: 'Employee Details',
      child: Column(
        children: [
          EmployeeSearchField(
            label: 'Employee ID',
            isRequired: true,
            selectedEmployee: state.selectedEmployee,
            enterpriseId: enterpriseId,
            hintText: 'Search employee by name or ID...',
            fillColor: context.themeCardBackground,
            onEmployeeSelected: (employee) => notifier.selectEmployee(employee, enterpriseId: enterpriseId),
          ),
          Gap(16.h),
          if (isMobile) ...[
            DigifyTextField(
              key: ValueKey('employee-name-${state.employeeName}'),
              labelText: 'Employee Name',
              hintText: 'Auto-filled from selected employee',
              initialValue: state.employeeName,
              readOnly: true,
              enabled: false,
              filled: true,
              fillColor: context.themeCardBackground,
            ),
            Gap(16.h),
            DigifyTextField(
              key: ValueKey('department-${state.department}'),
              labelText: 'Department',
              hintText: 'Auto-filled from selected employee',
              initialValue: state.department,
              readOnly: true,
              enabled: false,
              filled: true,
              fillColor: context.themeCardBackground,
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    key: ValueKey('employee-name-${state.employeeName}'),
                    labelText: 'Employee Name',
                    hintText: 'Auto-filled from selected employee',
                    initialValue: state.employeeName,
                    readOnly: true,
                    enabled: false,
                    filled: true,
                    fillColor: context.themeCardBackground,
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifyTextField(
                    key: ValueKey('department-${state.department}'),
                    labelText: 'Department',
                    hintText: 'Auto-filled from selected employee',
                    initialValue: state.department,
                    readOnly: true,
                    enabled: false,
                    filled: true,
                    fillColor: context.themeCardBackground,
                  ),
                ),
              ],
            ),
          Gap(16.h),
          if (isMobile) ...[
            DigifyTextField(
              key: ValueKey('position-${state.position}'),
              labelText: 'Position',
              hintText: 'Auto-filled from selected employee',
              initialValue: state.position,
              readOnly: true,
              enabled: false,
              filled: true,
              fillColor: context.themeCardBackground,
            ),
            Gap(16.h),
            DigifyTextField(
              key: ValueKey('grade-${state.grade}'),
              labelText: 'Grade',
              hintText: state.isLoadingEmployeeDetails ? 'Loading grade...' : 'Auto-filled from employee details',
              initialValue: state.grade,
              readOnly: true,
              enabled: false,
              filled: true,
              fillColor: context.themeCardBackground,
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: DigifyTextField(
                    key: ValueKey('position-${state.position}'),
                    labelText: 'Position',
                    hintText: 'Auto-filled from selected employee',
                    initialValue: state.position,
                    readOnly: true,
                    enabled: false,
                    filled: true,
                    fillColor: context.themeCardBackground,
                  ),
                ),
                Gap(16.w),
                Expanded(
                  child: DigifyTextField(
                    key: ValueKey('grade-${state.grade}'),
                    labelText: 'Grade',
                    hintText: state.isLoadingEmployeeDetails ? 'Loading grade...' : 'Auto-filled from employee details',
                    initialValue: state.grade,
                    readOnly: true,
                    enabled: false,
                    filled: true,
                    fillColor: context.themeCardBackground,
                  ),
                ),
              ],
            ),
          Gap(16.h),
          DigifyTextField(
            key: ValueKey('employment-type-${state.employmentType}'),
            labelText: 'Employment Type',
            hintText: state.isLoadingEmployeeDetails
                ? 'Loading employment type...'
                : 'Auto-filled from employee details',
            initialValue: state.employmentType,
            readOnly: true,
            enabled: false,
            filled: true,
            fillColor: context.themeCardBackground,
          ),
        ],
      ),
    );
  }
}
