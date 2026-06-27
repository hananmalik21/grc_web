import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/overtime_content.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/widgets/overtime/component_overtime_header.dart';
import 'package:flutter/material.dart';

class OvertimeTabletLayout extends StatelessWidget {
  const OvertimeTabletLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    required this.onNewOvertime,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback onNewOvertime;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return OvertimeContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: OvertimeScreenHeader(onNewOvertime: onNewOvertime, onExport: onExport, isExporting: isExporting),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
