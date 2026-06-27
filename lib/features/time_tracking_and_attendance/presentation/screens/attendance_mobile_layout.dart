import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_content.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AttendanceMobileLayout extends StatelessWidget with AttendancePermissionMixin {
  const AttendanceMobileLayout({
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
      header: DigifyMobileTabHeader(
        title: 'Daily Attendance',
        trailing: canCreateAttendance
            ? AppMobileButton.primary(svgPath: Assets.icons.addDivisionIcon.path, onPressed: onMarkAttendance)
            : null,
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
      onImport: () {},
      onExport: onExport,
      isExporting: isExporting,
    );
  }
}
