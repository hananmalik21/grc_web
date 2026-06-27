import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/requisitions_content.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_header.dart';
import 'package:flutter/material.dart';

class RequisitionsDesktopLayout extends StatelessWidget {
  const RequisitionsDesktopLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onExportPressed,
    required this.onNewRequisitionPressed,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onExportPressed;
  final VoidCallback onNewRequisitionPressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return RequisitionsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: RequisitionsHeader(
        onExportPressed: onExportPressed,
        onNewRequisitionPressed: onNewRequisitionPressed,
        isExporting: isExporting,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
