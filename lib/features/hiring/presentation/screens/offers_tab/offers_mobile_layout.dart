import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/hiring/presentation/screens/offers_tab/offers_content.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offers_header_actions.dart';
import 'package:flutter/material.dart';

class OffersMobileLayout extends StatelessWidget {
  const OffersMobileLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onCreateOfferPressed,
    required this.onExportPressed,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onCreateOfferPressed;
  final VoidCallback onExportPressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return OffersContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: loc.offerManagement,
        trailing: OffersHeaderActions(
          compact: true,
          onCreateOfferPressed: onCreateOfferPressed,
          onExportPressed: onExportPressed,
          isExporting: isExporting,
        ),
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onCreateOfferPressed: onCreateOfferPressed,
      onExportPressed: onExportPressed,
    );
  }
}
