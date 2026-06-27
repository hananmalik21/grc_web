import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../constants/app_colors.dart';
import '../../theme/theme_extensions.dart';

class AppErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;

  const AppErrorBanner({super.key, required this.message, this.onRetry, this.icon = Icons.error_outline_rounded});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.errorBgDark : AppColors.errorBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: isDark ? AppColors.errorBorderDark : AppColors.errorBorder, width: 1.w),
      ),
      child: Row(
        children: [
          Icon(icon, color: isDark ? AppColors.errorTextDark : AppColors.error, size: 18.w),
          Gap(12.w),
          Expanded(
            child: Text(
              message,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.errorTextDark : AppColors.errorText,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onRetry != null) ...[
            Gap(8.w),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Retry',
                style: context.textTheme.labelSmall?.copyWith(
                  color: isDark ? AppColors.onPrimary : AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
