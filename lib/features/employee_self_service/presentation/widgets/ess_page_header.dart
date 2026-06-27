import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EssPageHeader extends StatelessWidget {
  final String title;
  final String backIconAssetPath;
  final VoidCallback onBack;
  final List<Widget> actions;

  const EssPageHeader({
    super.key,
    required this.title,
    required this.backIconAssetPath,
    required this.onBack,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          DigifyAssetButton(onTap: onBack, assetPath: backIconAssetPath),
          Gap(16.w),
          Expanded(
            child: Text(
              title,
              style: context.textTheme.titleLarge?.copyWith(
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: textPrimary,
              ),
            ),
          ),
          if (actions.isNotEmpty) ...[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: actions
                  .map(
                    (w) => Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: w,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

