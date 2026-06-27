import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/forms/digify_text_field.dart';
import 'package:grc/core/widgets/forms/employee_search_field.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/attendance/mark_attendance_form_provider.dart';
import 'package:grc/features/workforce_structure/domain/models/employee.dart';
import 'package:flutter/material.dart';

class MarkAttendanceEmployeeField extends StatelessWidget {
  final int enterpriseId;
  final MarkAttendanceFormState state;
  final MarkAttendanceFormNotifier notifier;
  final bool readOnly;
  final TextEditingController? employeeNameController;

  const MarkAttendanceEmployeeField({
    super.key,
    required this.enterpriseId,
    required this.state,
    required this.notifier,
    this.readOnly = false,
    this.employeeNameController,
  });

  Employee? get _selectedEmployee {
    if (state.employeeId == null || state.employeeName == null) return null;
    final parts = (state.employeeName ?? '').trim().split(' ');
    final firstName = parts.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';
    return Employee(
      id: state.employeeId!,
      guid: '',
      enterpriseId: enterpriseId,
      firstName: firstName,
      lastName: lastName,
      email: '',
      employeeNumber: state.employeeNumber,
      status: 'active',
      isActive: true,
      createdAt: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    if (readOnly) {
      final disabledFillColor = isDark ? AppColors.inputBgDark : AppColors.inputBg;
      return DigifyTextField(
        controller: employeeNameController,
        labelText: 'Employee',
        isRequired: true,
        readOnly: true,
        hintText: '',
        filled: true,
        fillColor: disabledFillColor,
      );
    }
    return EmployeeSearchField(
      label: 'Select Employee',
      isRequired: true,
      enterpriseId: enterpriseId,
      selectedEmployee: _selectedEmployee,
      hintText: 'Search employees by name or number...',
      fillColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      onEmployeeSelected: (employee) {
        notifier.setEmployee(employee.id, employee.fullName, employee.employeeNumber);
      },
    );
  }
}

class MarkAttendanceEmployeeFieldPlaceholder extends StatelessWidget {
  const MarkAttendanceEmployeeFieldPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final disabledFillColor = isDark ? AppColors.inputBgDark : AppColors.inputBg;
    return DigifyTextField(
      labelText: 'Select Employee',
      isRequired: true,
      readOnly: true,
      hintText: 'Select an enterprise first',
      filled: true,
      fillColor: disabledFillColor,
    );
  }
}
