import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/features/hiring/presentation/screens/mixins/candidates_permission_mixin.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CandidatesHeaderActions extends StatelessWidget with CandidatesPermissionMixin {
  const CandidatesHeaderActions({
    super.key,
    this.onExportPressed,
    this.onNewCandidatePressed,
    this.compact = false,
    this.isExporting = false,
  });

  final VoidCallback? onExportPressed;
  final VoidCallback? onNewCandidatePressed;
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
          if (canCreateCandidate) ...[
            Gap(8.w),
            AppMobileButton.primary(icon: CupertinoIcons.add, onPressed: onNewCandidatePressed),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(
          label: loc.hiringCandidatesExport,
          onPressed: isExporting ? null : onExportPressed,
          isLoading: isExporting,
          svgPath: Assets.icons.downloadIcon.path,
        ),
        if (canCreateCandidate) ...[
          Gap(8.w),
          AppButton.primary(label: loc.hiringNewCandidate, icon: CupertinoIcons.add, onPressed: onNewCandidatePressed),
        ],
      ],
    );
  }
}
