import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/hiring/presentation/screens/requisitions_tab/requisitions_content.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_header_actions.dart';
import 'package:flutter/material.dart';

class RequisitionsMobileLayout extends StatelessWidget {
  const RequisitionsMobileLayout({
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
    final loc = AppLocalizations.of(context)!;

    return RequisitionsContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: loc.hiringRequisitionsTitle,
        trailing: RequisitionsHeaderActions(
          compact: true,
          onExportPressed: onExportPressed,
          onNewRequisitionPressed: onNewRequisitionPressed,
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
