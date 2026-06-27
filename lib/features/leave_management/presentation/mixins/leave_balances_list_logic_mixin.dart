import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:grc/core/utils/number_format_utils.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';
import 'package:grc/features/leave_management/presentation/widgets/adjust_leave_balance_dialog.dart';
import 'package:grc/features/leave_management/presentation/widgets/all_leave_balances/adjust_leave_balance_mobile_sheet.dart';
import 'package:grc/features/leave_management/presentation/widgets/all_leave_balances/leave_balance_details_mobile_sheet.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_details_dialog/leave_details_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin LeaveBalancesListLogicMixin {
  /// Opens the leave balance details view. Uses a bottom sheet on mobile,
  /// a dialog on larger screens.
  void openDetails(BuildContext context, LeaveBalanceSummaryItem item) {
    if (context.isMobile) {
      LeaveBalanceDetailsMobileSheet.show(context, item: item);
    } else {
      LeaveDetailsDialog.show(context, item: item);
    }
  }

  /// Opens the adjust leave balance form. Uses a bottom sheet on mobile,
  /// a dialog on larger screens.
  void openAdjust(BuildContext context, LeaveBalanceSummaryItem item) {
    if (context.isMobile) {
      AdjustLeaveBalanceMobileSheet.show(context, item: item);
    } else {
      AdjustLeaveBalanceDialog.show(context, item: item);
    }
  }

  String formatJoinDate(DateTime? date) {
    if (date == null) return '-';
    return DateFormat('yyyy-MM-dd').format(date);
  }

  String formatBalanceDays(double value, AppLocalizations localizations) {
    return '${NumberFormatUtils.formatDays(value)} ${localizations.days.toLowerCase()}';
  }
}
