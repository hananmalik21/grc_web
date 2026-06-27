import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/core/widgets/common/enterprise_selector_widget.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/attendance_summary_content.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';

class AttendanceSummaryTabletLayout extends StatelessWidget {
  const AttendanceSummaryTabletLayout({
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
    final localizations = AppLocalizations.of(context)!;

    return AttendanceSummaryContent(
      padding: ResponsiveHelper.getScreenPadding(context),
      header: DigifyTabHeader(
        title: 'Time & Labor Management - HR View',
        description: 'Comprehensive attendance, shifts, overtime and labor cost management',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              label: localizations.exportReport,
              onPressed: isExporting ? null : onExport,
              isLoading: isExporting,
              svgPath: Assets.icons.downloadIcon.path,
              backgroundColor: AppColors.shiftExportButton,
            ),
          ],
        ),
      ),
      enterpriseSelector: EnterpriseSelectorWidget(
        selectedEnterpriseId: selectedEnterpriseId,
        onEnterpriseChanged: onEnterpriseChanged,
      ),
    );
  }
}
