import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EligibilitySubsectionHeader extends StatelessWidget {
  final String title;
  final String iconPath;
  final bool isDark;

  const EligibilitySubsectionHeader({super.key, required this.title, required this.iconPath, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DigifyAsset(assetPath: iconPath, width: 20, height: 20, color: AppColors.primary),
        Gap(8.w),
        Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontSize: 14.sp,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
