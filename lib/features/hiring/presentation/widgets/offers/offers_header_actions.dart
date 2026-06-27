import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/buttons/app_mobile_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OffersHeaderActions extends StatelessWidget {
  const OffersHeaderActions({
    super.key,
    this.compact = false,
    this.onCreateOfferPressed,
    this.onExportPressed,
    this.isExporting = false,
  });

  final bool compact;
  final VoidCallback? onCreateOfferPressed;
  final VoidCallback? onExportPressed;
  final bool isExporting;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppMobileButton.outline(
            onPressed: isExporting ? null : onExportPressed,
            isLoading: isExporting,
            svgPath: Assets.icons.downloadIcon.path,
          ),
          Gap(8.w),
          AppMobileButton.primary(onPressed: onCreateOfferPressed, svgPath: Assets.icons.addDivisionIcon.path),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppButton.outline(
          label: 'Export',
          onPressed: isExporting ? null : onExportPressed,
          isLoading: isExporting,
          svgPath: Assets.icons.downloadIcon.path,
        ),
        Gap(8.w),
        AppButton.primary(
          label: loc.createOffer,
          onPressed: onCreateOfferPressed,
          svgPath: Assets.icons.addDivisionIcon.path,
        ),
      ],
    );
  }
}
