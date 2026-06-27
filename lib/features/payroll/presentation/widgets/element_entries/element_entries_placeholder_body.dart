import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ElementEntriesPlaceholderBody extends StatelessWidget {
  const ElementEntriesPlaceholderBody({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 80.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundGreyDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DigifyAsset(
            assetPath: Assets.icons.employeeListIcon.path,
            width: 48.w,
            height: 48.w,
            color: AppColors.primary,
          ),
          Gap(24.h),
          Text(
            loc.payrollElementEntriesEmptyTitle,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 18.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(12.h),
          SizedBox(
            width: 400.w,
            child: Text(
              loc.payrollElementEntriesEmptyMessage,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
