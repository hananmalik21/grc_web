import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/timesheet_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class TimesheetScreenHeader extends StatelessWidget with TimesheetPermissionMixin {
  final VoidCallback onNewTimesheet;
  final VoidCallback? onExport;
  final bool isExporting;

  const TimesheetScreenHeader({super.key, required this.onNewTimesheet, this.onExport, this.isExporting = false});

  @override
  Widget build(BuildContext context) {
    return DigifyTabHeader(
      title: 'Time Sheets',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: 'Import',
            onPressed: () {},
            svgPath: Assets.icons.bulkUploadIconFigma.path,
            backgroundColor: AppColors.shiftUploadButton,
          ),
          Gap(8.w),
          AppButton(
            label: 'Export',
            onPressed: isExporting ? null : onExport,
            isLoading: isExporting,
            svgPath: Assets.icons.downloadIcon.path,
            backgroundColor: AppColors.shiftExportButton,
          ),
          if (canCreateTimesheet) ...[
            Gap(8.w),
            AppButton.primary(
              label: 'New Timesheet',
              svgPath: Assets.icons.addDivisionIcon.path,
              onPressed: onNewTimesheet,
            ),
          ],
        ],
      ),
    );
  }
}
