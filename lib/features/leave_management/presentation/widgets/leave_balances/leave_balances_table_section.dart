import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_row.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_balances_table/leave_balances_table_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveBalancesTableSection extends StatelessWidget {
  final AppLocalizations localizations;
  final List<LeaveBalanceSummaryItem> items;
  final bool isDark;
  final bool isLoading;
  final String? error;
  final OnAdjustRequested? onAdjustRequested;

  const LeaveBalancesTableSection({
    super.key,
    required this.localizations,
    required this.items,
    required this.isDark,
    this.isLoading = false,
    this.error,
    this.onAdjustRequested,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 500.h),
      child: ScrollableSingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Skeletonizer(
          enabled: isLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LeaveBalancesTableHeader(isDark: isDark, localizations: localizations),
              if (error != null)
                _buildMessageState(16.sp, error!, AppColors.error)
              else if (isLoading && items.isEmpty)
                LeaveBalancesTableSkeleton(localizations: localizations)
              else if (items.isEmpty)
                _buildMessageState(16.sp, localizations.noResultsFound, AppColors.textMuted)
              else
                ...items.map((e) => LeaveBalancesTableRow(item: e, onAdjustRequested: onAdjustRequested)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageState(double fontSize, String text, Color color) {
    return SizedBox(
      width: 1800.w,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.h),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: fontSize, color: color),
          ),
        ),
      ),
    );
  }
}
