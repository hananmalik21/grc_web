import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/compensation/presentation/screens/salary_change_history/salary_change_history_content.dart';
import 'package:grc/features/compensation/presentation/widgets/salary_change_history/salary_change_history_header.dart';
import 'package:flutter/material.dart';

class SalaryChangeHistoryTabletLayout extends StatelessWidget {
  const SalaryChangeHistoryTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onSearchChanged,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return SalaryChangeHistoryContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      sectionSpacing: ResponsiveHelper.getTabSectionSpacing(context),
      header: const SalaryChangeHistoryHeader(),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onSearchChanged: onSearchChanged,
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
