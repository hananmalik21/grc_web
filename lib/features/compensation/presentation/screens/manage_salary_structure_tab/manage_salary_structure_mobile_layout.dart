import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/manage_salary_structure_content.dart';
import 'package:grc/features/compensation/presentation/screens/manage_salary_structure_tab/manage_salary_structure_tab_config.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/salary_structure_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class ManageSalaryStructureMobileLayout extends StatelessWidget with SalaryStructurePermissionMixin {
  const ManageSalaryStructureMobileLayout({
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
      header: DigifyMobileTabHeader(
        title: ManageSalaryStructureTabConfig.headerTitle,
        trailing: canCreateSalaryStructure
            ? AppMobileButton.primary(svgPath: Assets.icons.addNewIconFigma.path, onPressed: onCreatePressed)
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
