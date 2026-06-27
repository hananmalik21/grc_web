import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_summary_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AttendanceSummaryMobileLayout extends StatelessWidget {
  const AttendanceSummaryMobileLayout({
    required this.selectedEnterpriseId,
    required this.onEnterpriseChanged,
    this.onExport,
    this.isExporting = false,
    super.key,
  });

  final int? selectedEnterpriseId;
  final ValueChanged<int?> onEnterpriseChanged;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    return AttendanceSummaryContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyMobileTabHeader(
        title: 'Attendance Summary',
        trailing: AppMobileButton(
          svgPath: Assets.icons.downloadIcon.path,
          backgroundColor: AppColors.shiftExportButton,
          onPressed: isExporting ? null : onExport,
          isLoading: isExporting,
        ),
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
