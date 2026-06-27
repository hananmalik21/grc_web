import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/feedback/placeholder_screen.dart';
import 'package:flutter/material.dart';

class PerformanceTab extends StatelessWidget {
  const PerformanceTab({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return PlaceholderScreen(title: loc.employeeSelfServicePerformance);
  }
}

