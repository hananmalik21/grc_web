import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/manage_salary_structure_content.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/manage_salary_structure_tab_config.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/widgets/manage_salary_structure_header_actions.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/salary_structure_permission_mixin.dart';
import 'package:flutter/material.dart';

class ManageSalaryStructureDesktopLayout extends StatelessWidget with SalaryStructurePermissionMixin {
  const ManageSalaryStructureDesktopLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePressed,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreatePressed;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return ManageSalaryStructureContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: ManageSalaryStructureTabConfig.headerTitle,
        description: ManageSalaryStructureTabConfig.headerDescription,
        trailing: canCreateSalaryStructure
            ? ManageSalaryStructureHeaderActions(onCreatePressed: onCreatePressed)
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
