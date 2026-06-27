import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/compensation/presentation/screens/mixins/compensation_plans_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

import 'compensation_plans_content.dart';

class CompensationPlansMobileLayout extends StatelessWidget with CompensationPlansPermissionMixin {
  const CompensationPlansMobileLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreatePlanPressed,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final Future<void> Function() onCreatePlanPressed;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return CompensationPlansContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: 'Compensation Plans',
        trailing: canCreateCompensationPlan
            ? AppMobileButton.primary(
                svgPath: Assets.icons.addDivisionIcon.path,
                onPressed: () => onCreatePlanPressed(),
              )
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
