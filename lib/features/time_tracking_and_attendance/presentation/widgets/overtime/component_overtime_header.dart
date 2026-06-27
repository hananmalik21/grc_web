import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_tab_header.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/screens/mixins/overtime_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class OvertimeScreenHeader extends StatelessWidget with OvertimePermissionMixin {
  const OvertimeScreenHeader({required this.onNewOvertime, this.onExport, this.isExporting = false, super.key});

  final VoidCallback onNewOvertime;
  final VoidCallback? onExport;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return DigifyTabHeader(
      title: 'Overtime',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppButton(
            label: localizations.export,
            onPressed: isExporting ? null : onExport,
            isLoading: isExporting,
            svgPath: Assets.icons.downloadIcon.path,
            backgroundColor: AppColors.shiftExportButton,
          ),
          if (canCreateOvertime) ...[
            Gap(8.w),
            AppButton.primary(
              label: localizations.requestOvertime,
              svgPath: Assets.icons.addNewIconFigma.path,
              onPressed: onNewOvertime,
            ),
          ],
        ],
      ),
    );
  }
}
