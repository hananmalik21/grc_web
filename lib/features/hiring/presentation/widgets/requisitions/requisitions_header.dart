import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/hiring/presentation/widgets/requisitions/requisitions_header_actions.dart';
import 'package:flutter/material.dart';

class RequisitionsHeader extends StatelessWidget {
  const RequisitionsHeader({super.key, this.onExportPressed, this.onNewRequisitionPressed, this.isExporting = false});

  final VoidCallback? onExportPressed;
  final VoidCallback? onNewRequisitionPressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DigifyTabHeader(
      title: loc.hiringRequisitionsTitle,
      description: loc.hiringRequisitionsDescription,
      trailing: RequisitionsHeaderActions(
        onExportPressed: onExportPressed,
        onNewRequisitionPressed: onNewRequisitionPressed,
        isExporting: isExporting,
      ),
    );
  }
}
