import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/hiring/presentation/widgets/offers/offers_header_actions.dart';
import 'package:flutter/material.dart';

class OffersHeader extends StatelessWidget {
  const OffersHeader({super.key, this.onCreateOfferPressed, this.onExportPressed, this.isExporting = false});

  final VoidCallback? onCreateOfferPressed;
  final VoidCallback? onExportPressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DigifyTabHeader(
      title: loc.offerManagement,
      description: loc.offerManagementSubtitle,
      trailing: OffersHeaderActions(
        onCreateOfferPressed: onCreateOfferPressed,
        onExportPressed: onExportPressed,
        isExporting: isExporting,
      ),
    );
  }
}
