import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/presentation/widgets/work_patterns/components/work_pattern_table_row.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkPatternTableSkeleton extends StatelessWidget {
  final AppLocalizations localizations;

  const WorkPatternTableSkeleton({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          8,
          (index) => WorkPatternTableRow(
            workPattern: WorkPattern(
              workPatternId: 0,
              tenantId: 0,
              patternCode: 'PAT-000000',
              patternNameEn: 'Work Pattern Name English Extended',
              patternNameAr: 'عربي اسم نمط العمل',
              patternType: 'STANDARD',
              totalHoursPerWeek: 40,
              status: PositionStatus.active,
              creationDate: DateTime.now(),
              createdBy: 'SYSTEM',
              lastUpdateDate: DateTime.now(),
              lastUpdatedBy: 'ADMIN',
              days: const [],
            ),
            onView: null,
            onEdit: null,
            onDelete: null,
          ),
        ),
      ),
    );
  }
}
