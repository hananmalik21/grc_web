import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/workforce_structure/domain/models/position.dart';
import 'package:grc/features/workforce_structure/presentation/widgets/positions/table/position_table_row.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PositionTableSkeleton extends StatelessWidget {
  final AppLocalizations localizations;

  const PositionTableSkeleton({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          8,
          (index) => PositionTableRow(
            position: Position.empty().copyWith(
              code: 'POS-000000',
              titleEnglish: 'Position Title English Extended',
              titleArabic: 'عربي مسمى وظيفة',
              department: 'Department Name Engineering',
              jobFamily: 'Technical Services',
              level: 'Senior Professional',
              grade: '12',
              step: '5',
              reportsTo: 'Management Position',
              headcount: 10,
              filled: 5,
              vacant: 5,
            ),
            localizations: localizations,
            onView: (_) {},
            onEdit: (_) {},
            onDelete: (_) {},
          ),
        ),
      ),
    );
  }
}
