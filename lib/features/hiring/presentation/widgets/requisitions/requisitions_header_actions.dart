import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/requisitions_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class RequisitionsHeaderActions extends StatelessWidget with RequisitionsPermissionMixin {
  const RequisitionsHeaderActions({
    super.key,
    this.onExportPressed,
    this.onNewRequisitionPressed,
    this.compact = false,
    this.isExporting = false,
  });

  final VoidCallback? onExportPressed;
  final VoidCallback? onNewRequisitionPressed;
  final bool compact;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppMobileButton.outline(
            svgPath: Assets.icons.downloadIcon.path,
            onPressed: isExporting ? null : onExportPressed,
            isLoading: isExporting,
          ),
          if (canCreateRequisition) ...[
            Gap(8.w),
            AppMobileButton.primary(icon: CupertinoIcons.add, onPressed: onNewRequisitionPressed),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(
          label: loc.hiringRequisitionsExport,
          onPressed: isExporting ? null : onExportPressed,
          isLoading: isExporting,
          svgPath: Assets.icons.downloadIcon.path,
        ),
        if (canCreateRequisition) ...[
          Gap(8.w),
          AppButton.primary(
            label: loc.hiringNewRequisition,
            icon: CupertinoIcons.add,
            onPressed: onNewRequisitionPressed,
          ),
        ],
      ],
    );
  }
}
