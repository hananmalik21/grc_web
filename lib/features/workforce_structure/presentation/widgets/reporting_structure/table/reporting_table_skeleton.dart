import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/workforce_structure/domain/models/reporting_position.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/reporting_structure/table/reporting_table_row.dart';
import 'package:flutter/material.dart';

class ReportingTableSkeleton extends StatelessWidget {
  final AppLocalizations localizations;

  const ReportingTableSkeleton({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        5,
        (index) => ReportingTableRow(
          position: ReportingPosition(
            positionId: 'skeleton-$index',
            positionCode: 'POS-001',
            titleEnglish: 'Position Title',
            titleArabic: 'Position Title',
            department: 'Department',
            level: 'Level',
            gradeStep: 'Grade/Step',
            reportsToTitle: 'Reports To',
            reportsToCode: 'CODE',
            directReportsCount: 0,
            status: 'active',
          ),
          isDark: false,
          localizations: localizations,
        ),
      ),
    );
  }
}
