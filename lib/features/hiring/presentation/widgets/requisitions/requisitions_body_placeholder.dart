import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequisitionsBodyPlaceholder extends StatelessWidget {
  const RequisitionsBodyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    final borderColor = isDark ? AppColors.cardBorderDark : AppColors.cardBorder;
    final secondaryTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final titleColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 48.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(Icons.description_outlined, size: 48.sp, color: secondaryTextColor),
          SizedBox(height: 16.h),
          Text(
            loc.hiringRequisitionsTitle,
            style: context.textTheme.titleMedium?.copyWith(color: titleColor),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            loc.hiringRequisitionsDescription,
            style: context.textTheme.bodyMedium?.copyWith(color: secondaryTextColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
