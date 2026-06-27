import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/hiring/presentation/widgets/candidates/candidates_header_actions.dart';
import 'package:flutter/material.dart';

class CandidatesHeader extends StatelessWidget {
  const CandidatesHeader({super.key, this.onExportPressed, this.onNewCandidatePressed, this.isExporting = false});

  final VoidCallback? onExportPressed;
  final VoidCallback? onNewCandidatePressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DigifyTabHeader(
      title: loc.hiringCandidatesTitle,
      description: loc.hiringCandidatesDescription,
      trailing: CandidatesHeaderActions(
        onExportPressed: onExportPressed,
        onNewCandidatePressed: onNewCandidatePressed,
        isExporting: isExporting,
      ),
    );
  }
}
