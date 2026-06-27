import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../gen/assets.gen.dart';
import '../../constants/app_colors.dart';

class ImportButton extends StatelessWidget {
  final VoidCallback onTap;
  final String? customLabel;
  final Color? backgroundColor;
  final Color? textColor;
  final double? iconSize;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const ImportButton({super.key, required this.onTap, this.customLabel, this.backgroundColor, this.textColor, this.iconSize, this.fontSize, this.padding});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return CustomButton(
      label: customLabel ?? localizations.import,
      svgIcon: Assets.icons.bulkUploadIconFigma.path,
      onPressed: onTap,
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: textColor ??
          (context.isDark ? Colors.white : AppColors.sidebarMenuItemText),
      iconSize: 14,
      fontSize: 14.h,
      borderColor: AppColors.inputBorder,
      borderRadius: 7,
      padding: EdgeInsets.symmetric(horizontal: 14.w,vertical: 7.h),
    );
  }
}
