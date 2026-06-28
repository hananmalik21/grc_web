import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/grc_brand_mark.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginWelcomeHero extends StatelessWidget {
  const LoginWelcomeHero({
    super.key,
    this.gapAfterLogo,
    this.previewHeight,
    this.expandPreview = false,
  });

  final double? gapAfterLogo;
  final double? previewHeight;
  final bool expandPreview;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isDark = context.isDark;
    final titleColor = isDark
        ? AppColors.textPrimaryDark
        : AppColors.blackTextColor;
    final descriptionColor = isDark
        ? AppColors.textSecondaryDark
        : AppColors.textSecondary;
    final logoGap = gapAfterLogo ?? 32.h;

    final preview = switch ((expandPreview, previewHeight)) {
      (true, _) => const Expanded(child: LoginDashboardPreview()),
      (false, final height?) => SizedBox(
        height: height,
        child: const LoginDashboardPreview(),
      ),
      (false, null) => const LoginDashboardPreview(),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GrcBrandMark(fontSize: 32.sp),
        Gap(logoGap),
        Text(
          localizations.loginDesktopWelcomeTitle,
          style: context.textTheme.displaySmall?.copyWith(
            fontSize: expandPreview ? 36.sp : 28.sp,
            color: titleColor,
          ),
        ),
        Gap(16.h),
        Text(
          localizations.loginDesktopWelcomeDescription,
          style: context.textTheme.bodyLarge?.copyWith(
            fontSize: expandPreview ? 16.sp : 14.sp,
            color: descriptionColor,
          ),
        ),
        Gap(32.h),
        preview,
      ],
    );
  }
}

class LoginDashboardPreview extends StatelessWidget {
  const LoginDashboardPreview({super.key});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(10.r);

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 50,
            spreadRadius: -12,
          ),
        ],
      ),
      clipBehavior: Clip.none,
      child: ClipRRect(
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        child: SizedBox.expand(
          child: DigifyAsset(
            assetPath: Assets.icons.auth.authDashbaord.path,
            fit: BoxFit.fill,
            borderRadius: borderRadius,
          ),
        ),
      ),
    );
  }
}
