import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 3.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppColors.sidebarTextSecondary.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(5.r),
              ),
            ),
            const Gap(8),
            Text(
              localizations.endToEndEncrypted,
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                fontSize: 8.sp,
                color: AppColors.sidebarTextSecondary,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        Gap(27.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.copyright_rounded,
              size: 12.sp,
              color: AppColors.sidebarTextSecondary.withValues(alpha: 0.8),
            ),
            Gap(6.w),
            Text(
              localizations.copyrightInfo,
              textAlign: TextAlign.center,
              style: AppTextTheme.lightTextTheme.headlineMedium?.copyWith(
                fontSize: 10.sp,
                color: AppColors.sidebarTextSecondary.withValues(alpha: 0.8),
                letterSpacing: 4.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
