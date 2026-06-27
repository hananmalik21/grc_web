import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';

class CompensationComponentTypeBadge extends StatelessWidget {
  final String type;

  const CompensationComponentTypeBadge({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    Color backgroundColor;
    Color textColor;

    if (type.toLowerCase() == 'base') {
      backgroundColor = isDark ? AppColors.infoBgDark : AppColors.infoBg;
      textColor = isDark ? AppColors.infoTextDark : AppColors.infoText;
    } else if (type.toLowerCase() == 'allowance') {
      backgroundColor = isDark ? AppColors.warningBgDark : AppColors.warningBg;
      textColor = isDark ? AppColors.warningTextDark : AppColors.warningText;
    } else {
      backgroundColor = isDark ? AppColors.grayBgDark : AppColors.tableHeaderBackground;
      textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    }

    return DigifyCapsule(label: type, backgroundColor: backgroundColor, textColor: textColor);
  }
}
