import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/compensation/presentation/screens/employee_compensation/employee_compensation_content.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/employee_compensation_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class EmployeeCompensationMobileLayout extends StatelessWidget with EmployeeCompensationPermissionMixin {
  const EmployeeCompensationMobileLayout({
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
      header: DigifyMobileTabHeader(
        title: 'Employee Compensation',
        trailing: canCreateEmployeeCompensation
            ? AppMobileButton.primary(svgPath: Assets.icons.addNewIconFigma.path, onPressed: onCreatePressed)
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      searchController: searchController,
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
