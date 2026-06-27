import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/scrollable_wrapper.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_table_header.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_request_employee_detail/leave_request_employee_detail_table_row.dart';
import 'package:grc/features/leave_management/presentation/widgets/leave_requests_table/leave_request_details_dialog.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';
import 'package:flutter/material.dart';

class LeaveRequestEmployeeDetailTable extends StatelessWidget {
  const LeaveRequestEmployeeDetailTable({
    super.key,
    required this.requests,
    required this.employeeGuid,
    required this.page,
    required this.pageSize,
    required this.isDark,
    required this.localizations,
    this.onRefresh,
  });

  final List<TimeOffRequest> requests;
  final String employeeGuid;
  final int page;
  final int pageSize;
  final bool isDark;
  final AppLocalizations localizations;
  final VoidCallback? onRefresh;

  @override
  Widget build(BuildContext context) {
    return ScrollableSingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeaveRequestEmployeeDetailTableHeader(isDark: isDark, localizations: localizations),
          ...requests.map(
            (req) => LeaveRequestEmployeeDetailTableRow(
              request: req,
              localizations: localizations,
              isDark: isDark,
              onView: () => LeaveRequestDetailsDialog.show(
                context,
                request: req,
                department: req.department,
                position: req.position,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
