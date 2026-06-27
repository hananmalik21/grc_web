import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_content.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_permission_mixin.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/adjustments_tab_config.dart';
import 'package:grc/features/compensation/presentation/screens/adjustments/widgets/adjustments_header_actions.dart';
import 'package:flutter/material.dart';

class AdjustmentsTabletLayout extends StatelessWidget with AdjustmentsPermissionMixin {
  const AdjustmentsTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePressed,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return AdjustmentsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: DigifyTabHeader(
        title: AdjustmentsTabConfig.headerTitle,
        description: AdjustmentsTabConfig.headerDescription,
        trailing: canCreateAdjustment ? AdjustmentsHeaderActions(onCreatePressed: onCreatePressed) : null,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
