import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_buildLogoSection(), _buildLanguageSelector(context)]);
  }

  Widget _buildLogoSection() {
    return Positioned(
      top: 24.h,
      left: 40.w,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(4.r),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: Assets.icons.auth.secureShield.path, width: 22.w, height: 22.h),
          ),
          const Gap(10),
          DigifyAsset(assetPath: Assets.logo.partLogo.path),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(BuildContext context) {
    return Positioned(
      top: 24.h,
      right: 40.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 6.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.authInputBorder.withValues(alpha: 0.6)),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DigifyAsset(assetPath: Assets.icons.header.language.path, color: AppColors.primary),
            Gap(7.w),
            Text(
              'English | العربية',
              style: context.textTheme.displayMedium?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.sidebarSecondaryText,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
