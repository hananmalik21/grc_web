import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/project_search_field.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/new_timesheet_provider.dart';

class NewTimesheetBasicForm extends StatelessWidget {
  const NewTimesheetBasicForm({
    super.key,
    required this.state,
    required this.notifier,
    required this.enterpriseId,
    required this.employeeNameController,
    required this.positionController,
    required this.departmentController,
    required this.descriptionController,
  });

  final NewTimesheetFormState state;
  final NewTimesheetNotifier notifier;
  final int? enterpriseId;
  final TextEditingController employeeNameController;
  final TextEditingController positionController;
  final TextEditingController departmentController;
  final TextEditingController descriptionController;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final disabledFillColor = isDark ? AppColors.inputBgDark : AppColors.inputBg;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (enterpriseId != null)
          EmployeeSearchField(
            label: 'Select Employee',
            isRequired: true,
            enterpriseId: enterpriseId!,
            selectedEmployee: null,
            onEmployeeSelected: (employee) {
              notifier.setEmployee(employeeId: employee.id, employeeName: employee.fullName);
              notifier.setPosition(employee.positionTitle);
              notifier.setDepartmentId(employee.departmentName);
            },
          )
        else
          DigifyTextField(
            labelText: 'Select Employee',
            isRequired: true,
            readOnly: true,
            hintText: 'Select an enterprise first',
            filled: true,
            fillColor: disabledFillColor,
          ),
        Gap(16.h),
        if (context.isMobile) ...[
          DigifyTextField(
            labelText: 'Employee Name',
            hintText: 'Auto-filled from selected employee',
            controller: employeeNameController,
            readOnly: true,
            filled: true,
            fillColor: disabledFillColor,
          ),
          Gap(16.h),
          ProjectSearchField(
            label: 'Project',
            isRequired: false,
            enterpriseId: enterpriseId!,
            selectedProject: null,
            onProjectSelected: (project) {
              notifier.setProject(projectId: project.id, projectName: project.name);
            },
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: 'Employee Name',
                  hintText: 'Auto-filled from selected employee',
                  controller: employeeNameController,
                  readOnly: true,
                  filled: true,
                  fillColor: disabledFillColor,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: ProjectSearchField(
                  label: 'Project',
                  isRequired: false,
                  enterpriseId: enterpriseId!,
                  selectedProject: null,
                  onProjectSelected: (project) {
                    notifier.setProject(projectId: project.id, projectName: project.name);
                  },
                ),
              ),
            ],
          ),
        ],
        Gap(16.h),
        if (context.isMobile) ...[
          DigifyTextField(
            labelText: 'Position',
            hintText: 'Auto-filled from employee position',
            controller: positionController,
            readOnly: true,
            filled: true,
            fillColor: disabledFillColor,
          ),
          Gap(16.h),
          DigifyTextField(
            labelText: 'Department',
            hintText: 'Auto-filled from employee department',
            controller: departmentController,
            readOnly: true,
            filled: true,
            fillColor: disabledFillColor,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: DigifyTextField(
                  labelText: 'Position',
                  hintText: 'Auto-filled from employee position',
                  controller: positionController,
                  readOnly: true,
                  filled: true,
                  fillColor: disabledFillColor,
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyTextField(
                  labelText: 'Department',
                  hintText: 'Auto-filled from employee department',
                  controller: departmentController,
                  readOnly: true,
                  filled: true,
                  fillColor: disabledFillColor,
                ),
              ),
            ],
          ),
        ],
        Gap(16.h),
        if (context.isMobile) ...[
          DigifyDateField(
            label: 'Week Starting',
            isRequired: true,
            initialDate: state.startDate,
            lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
            onDateSelected: notifier.setStartDate,
            hintText: 'Select start date',
          ),
          Gap(16.h),
          DigifyDateField(
            label: 'Week Ending',
            isRequired: true,
            initialDate: state.endDate,
            onDateSelected: notifier.setEndDate,
            hintText: 'Select end date',
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: 'Description',
            hintText: 'Enter description (optional)',
            controller: descriptionController,
            onChanged: notifier.setDescription,
            minLines: 3,
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: DigifyDateField(
                  label: 'Week Starting',
                  isRequired: true,
                  initialDate: state.startDate,
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  onDateSelected: notifier.setStartDate,
                  hintText: 'Select start date',
                ),
              ),
              Gap(16.w),
              Expanded(
                child: DigifyDateField(
                  label: 'Week Ending',
                  isRequired: true,
                  initialDate: state.endDate,
                  onDateSelected: notifier.setEndDate,
                  hintText: 'Select end date',
                ),
              ),
            ],
          ),
          Gap(16.h),
          DigifyTextArea(
            labelText: 'Description',
            hintText: 'Enter description (optional)',
            controller: descriptionController,
            onChanged: notifier.setDescription,
            minLines: 3,
          ),
        ],
        Gap(16.h),
      ],
    );
  }
}
