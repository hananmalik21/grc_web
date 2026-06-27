import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/widgets/common/info_guidelines_box.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeclarationSection extends StatelessWidget {
  const DeclarationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return InfoGuidelinesBox(
      title: localizations.declaration,
      messages: [localizations.declarationText],
      iconAssetPath: Assets.icons.checkIconGreen.path,
      spacing: 8.h,
      iconColor: AppColors.shiftCreateButton,
      iconBackgroundColor: Colors.transparent,
      titleColor: AppColors.infoText,
      messageColor: AppColors.infoTextSecondary,
    );
  }
}
