import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/features/employee_management/presentation/screens/manage_employees/manage_employees_content.dart';
import 'package:flutter/material.dart';

class ManageEmployeesTabletLayout extends StatelessWidget {
  const ManageEmployeesTabletLayout({required this.onAddEmployeePressed, required this.onEnterpriseChanged, super.key});

  final VoidCallback onAddEmployeePressed;
  final ValueChanged<int?> onEnterpriseChanged;

  @override
  Widget build(BuildContext context) {
    return ManageEmployeesContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      onAddEmployeePressed: onAddEmployeePressed,
      onEnterpriseChanged: onEnterpriseChanged,
    );
  }
}
