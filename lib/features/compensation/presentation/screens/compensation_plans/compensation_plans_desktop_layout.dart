import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plans_header.dart';
import 'package:flutter/material.dart';

import 'compensation_plans_content.dart';

class CompensationPlansDesktopLayout extends StatelessWidget {
  const CompensationPlansDesktopLayout({
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
      header: CompensationPlansHeader(onCreatePlanPressed: onCreatePlanPressed),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
