import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/project_search_field.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/project.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/timesheet/edit_timesheet_provider.dart';

class EditTimesheetBasicForm extends StatelessWidget {
  const EditTimesheetBasicForm({
    super.key,
    required this.state,
    required this.notifier,
    required this.enterpriseId,
    required this.employeeNameController,
    required this.positionController,
    required this.departmentController,
    required this.descriptionController,
  });

  final EditTimesheetFormState state;
  final EditTimesheetNotifier notifier;
  final int? enterpriseId;
  final TextEditingController employeeNameController;
  final TextEditingController positionController;
  final TextEditingController departmentController;
  final TextEditingController descriptionController;

  Employee? _selectedEmployeeFromState() {
    if (enterpriseId == null ||
        state.employeeId == null ||
        state.employeeName == null ||
        state.employeeName!.trim().isEmpty) {
      return null;
    }
    final parts = state.employeeName!.trim().split(RegExp(r'\s+'));
    final firstName = parts.isNotEmpty ? parts.first : state.employeeName!;
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return Employee(
      id: state.employeeId!,
      guid: '',
      enterpriseId: enterpriseId!,
      firstName: firstName,
      middleName: null,
      lastName: lastName,
      email: '',
      status: 'Active',
      isActive: true,
      createdAt: DateTime(2000),
      positionTitle: state.position,
      departmentName: state.departmentId,
      employeeNumber: null,
    );
  }

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
            selectedEmployee: _selectedEmployeeFromState(),
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
            selectedProject: state.projectId != null && state.projectName != null && state.projectName!.isNotEmpty
                ? Project(
                    id: state.projectId!,
                    guid: '',
                    enterpriseId: enterpriseId!,
                    code: '',
                    name: state.projectName!,
                    status: '',
                  )
                : null,
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
                  selectedProject: state.projectId != null && state.projectName != null && state.projectName!.isNotEmpty
                      ? Project(
                          id: state.projectId!,
                          guid: '',
                          enterpriseId: enterpriseId!,
                          code: '',
                          name: state.projectName!,
                          status: '',
                        )
                      : null,
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
