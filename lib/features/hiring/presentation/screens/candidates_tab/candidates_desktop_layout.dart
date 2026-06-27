import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_content.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_header.dart';
import 'package:flutter/material.dart';

class CandidatesDesktopLayout extends StatelessWidget {
  const CandidatesDesktopLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onExportPressed,
    required this.onNewCandidatePressed,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onExportPressed;
  final VoidCallback onNewCandidatePressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return CandidatesContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: CandidatesHeader(
        onExportPressed: onExportPressed,
        onNewCandidatePressed: onNewCandidatePressed,
        isExporting: isExporting,
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
