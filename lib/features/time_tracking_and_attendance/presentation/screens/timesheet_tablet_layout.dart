import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_content.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/timesheet/component_timesheet_header.dart';
import 'package:flutter/material.dart';

class TimesheetTabletLayout extends StatelessWidget {
  const TimesheetTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onNewTimesheet,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onNewTimesheet;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return TimesheetContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: TimesheetScreenHeader(onNewTimesheet: onNewTimesheet, onExport: onExport, isExporting: isExporting),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
