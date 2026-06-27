import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/hiring/presentation/screens/candidates_tab/candidates_content.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_header_actions.dart';
import 'package:flutter/material.dart';

class CandidatesMobileLayout extends StatelessWidget {
  const CandidatesMobileLayout({
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
    final loc = AppLocalizations.of(context)!;

    return CandidatesContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: loc.hiringCandidatesTitle,
        trailing: CandidatesHeaderActions(
          compact: true,
          onExportPressed: onExportPressed,
          onNewCandidatePressed: onNewCandidatePressed,
          isExporting: isExporting,
        ),
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
