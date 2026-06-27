import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/compensation/presentation/screens/employee_compensation/employee_compensation_content.dart';
import 'package:grc/features/compensation/presentation/widgets/employee_compensation/employee_compensation_header.dart';
import 'package:flutter/material.dart';

class EmployeeCompensationTabletLayout extends StatelessWidget {
  const EmployeeCompensationTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePressed,
    required this.searchController,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreatePressed;
  final TextEditingController searchController;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return EmployeeCompensationContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: EmployeeCompensationHeader(onCreatePressed: onCreatePressed),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      searchController: searchController,
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
