import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../../core/localization/l10n/app_localizations.dart';
import '../../../../domain/models/overtime/overtime_record.dart';
import 'overtime_table_row.dart';

class OvertimeTableSkeleton extends StatelessWidget {
  final AppLocalizations localizations;
  final bool isDark;
  const OvertimeTableSkeleton({super.key, required this.localizations, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(
          10,
          (index) => OvertimeTableRow(
            record: OvertimeRecord.empty().copyWith(),
            localizations: localizations,
            isDark: isDark,
            isExpanded: false,
            onToggle: () {},
          ),
        ),
      ),
    );
  }
}
