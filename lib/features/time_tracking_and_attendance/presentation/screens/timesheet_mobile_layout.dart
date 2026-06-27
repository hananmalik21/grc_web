import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/core/widgets/common/digify_mobile_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_mobile_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_content.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TimesheetMobileLayout extends StatelessWidget with TimesheetPermissionMixin {
  const TimesheetMobileLayout({
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
      header: DigifyMobileTabHeader(
        title: 'Time Sheets',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppMobileButton(
              svgPath: Assets.icons.downloadIcon.path,
              backgroundColor: AppColors.shiftExportButton,
              onPressed: isExporting ? null : onExport,
              isLoading: isExporting,
            ),
            if (canCreateTimesheet) ...[
              const Gap(8),
              AppMobileButton.primary(svgPath: Assets.icons.addDivisionIcon.path, onPressed: onNewTimesheet),
            ],
          ],
        ),
      ),
      enterpriseSelector: EnterpriseSelectorMobileWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
