import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_row.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveBalancesTableSkeleton extends StatelessWidget {
  final AppLocalizations localizations;

  const LeaveBalancesTableSkeleton({super.key, required this.localizations});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: List.generate(8, (_) => LeaveBalancesTableRow(item: LeaveBalanceSummaryItem.skeletonPlaceholder())),
      ),
    );
  }
}
