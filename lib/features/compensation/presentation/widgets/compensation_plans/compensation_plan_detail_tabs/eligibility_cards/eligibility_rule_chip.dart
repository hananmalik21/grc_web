import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EligibilityRuleChip extends StatelessWidget {
  final String label;

  const EligibilityRuleChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return DigifyCapsule(
      label: label,
      backgroundColor: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
      borderColor: isDark ? AppColors.borderGreyDark : AppColors.cardBorder,
      textColor: isDark ? AppColors.textSecondaryDark : AppColors.sidebarSecondaryText,
      textStyle: context.textTheme.labelMedium?.copyWith(fontSize: 12.sp, fontWeight: FontWeight.w600),
      borderRadius: 10.r,
    );
  }
}
