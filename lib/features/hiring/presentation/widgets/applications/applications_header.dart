import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:flutter/material.dart';

class ApplicationsHeader extends StatelessWidget {
  const ApplicationsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return DigifyTabHeader(title: loc.hiringApplicationsTitle, description: loc.hiringApplicationsDescription);
  }
}
