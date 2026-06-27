import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_content.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/attendance/component_attendance_header.dart';
import 'package:flutter/material.dart';

class AttendanceDesktopLayout extends StatelessWidget {
  const AttendanceDesktopLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onMarkAttendance,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onMarkAttendance;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return AttendanceContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: AttendanceScreenHeader(onMarkAttendance: onMarkAttendance, onExport: onExport, isExporting: isExporting),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
