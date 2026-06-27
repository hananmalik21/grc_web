import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class DigifyErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;
  final String? retryLabel;
  final String? assetPath;
  final double? iconSize;

  const DigifyErrorState({super.key, this.message, this.onRetry, this.retryLabel, this.assetPath, this.iconSize});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 64.h, horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DigifyAsset(
              assetPath: assetPath ?? Assets.icons.errorCircleRed.path,
              width: iconSize ?? 64.sp,
              height: iconSize ?? 64.sp,
              color: AppColors.brandRed,
            ),
            Gap(24.h),
            Text(
              message ?? 'Something went wrong',
              style: context.textTheme.titleLarge?.copyWith(
                color: isDark ? context.themeTextPrimary : AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              Gap(24.h),
              AppButton(label: retryLabel ?? 'Retry', onPressed: onRetry, width: 140.w, height: 40.h),
            ],
          ],
        ),
      ),
    );
  }
}
