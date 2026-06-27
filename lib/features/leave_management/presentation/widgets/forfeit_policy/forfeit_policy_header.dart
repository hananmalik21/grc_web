import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/core/widgets/common/digify_capsule.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForfeitPolicyHeader extends StatelessWidget {
  final String policyName;
  final String policyNameArabic;
  final bool isPolicyActive;
  final bool isForfeitEnabled;
  final VoidCallback? onEditPressed;
  final bool isDark;

  const ForfeitPolicyHeader({
    super.key,
    required this.policyName,
    required this.policyNameArabic,
    this.isPolicyActive = true,
    this.isForfeitEnabled = true,
    this.onEditPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  policyName,
                  style: context.textTheme.headlineMedium?.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                Gap(4.h),
                Text(
                  policyNameArabic,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                Gap(14.h),
                Row(
                  children: [
                    Container(
                      width: 17.w,
                      height: 17.h,
                      decoration: BoxDecoration(
                        color: isForfeitEnabled ? AppColors.primary : AppColors.grayBg,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    Gap(7.w),
                    Text(
                      'Enable Forfeit Policy',
                      style: context.textTheme.titleSmall?.copyWith(
                        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                      ),
                    ),
                    Gap(11.w),
                    DigifyCapsule(
                      label: 'Policy Active',
                      backgroundColor: isPolicyActive
                          ? (isDark ? AppColors.successBgDark : const Color(0xFFDCFCE7))
                          : (isDark ? AppColors.grayBgDark : AppColors.grayBg),
                      textColor: isPolicyActive
                          ? (isDark ? AppColors.successTextDark : const Color(0xFF016630))
                          : (isDark ? AppColors.grayTextDark : AppColors.grayText),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppButton.primary(label: 'Edit Policy', svgPath: Assets.icons.editIconGreen.path, onPressed: onEditPressed),
        ],
      ),
    );
  }
}
