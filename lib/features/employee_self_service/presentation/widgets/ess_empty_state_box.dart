import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/buttons/app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class EssEmptyStateBox extends StatelessWidget {
  final String iconPath;
  final String title;
  final String subtitle;
  final String primaryActionLabel;
  final VoidCallback onPrimaryAction;
  final bool dashedBorder;
  final Color? dashedBorderColor;

  const EssEmptyStateBox({
    super.key,
    required this.iconPath,
    required this.title,
    required this.subtitle,
    required this.primaryActionLabel,
    required this.onPrimaryAction,
    this.dashedBorder = false,
    this.dashedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final borderColor = dashedBorderColor ?? (isDark ? AppColors.cardBorderDark : AppColors.sidebarCategoryText);

    return CustomPaint(
      foregroundPainter: dashedBorder ? _DottedBorderPainter(borderColor: borderColor, borderRadius: BorderRadius.circular(10.r)) : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 28.h),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.sidebarSearchBg,
          borderRadius: BorderRadius.circular(10.r),
          border: dashedBorder ? null : Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            DigifyAsset(assetPath: iconPath, width: 34, height: 34, color: context.themeTextMuted),
            Gap(10.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: context.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gap(4.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall?.copyWith(
                color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiary,
              ),
            ),
            Gap(14.h),
            AppButton.primary(
              label: primaryActionLabel,
              onPressed: onPrimaryAction,
            ),
          ],
        ),
      ),
    );
  }
}

class _DottedBorderPainter extends CustomPainter {
  final Color borderColor;
  final BorderRadius borderRadius;

  const _DottedBorderPainter({
    required this.borderColor,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(1, 1, size.width - 2, size.height - 2);
    final path = Path()..addRRect(borderRadius.toRRect(rect));
    const dashLength = 6.0;
    const dashGap = 4.0;

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashLength;
        canvas.drawPath(metric.extractPath(distance, next.clamp(0, metric.length)), paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DottedBorderPainter oldDelegate) {
    return oldDelegate.borderColor != borderColor || oldDelegate.borderRadius != borderRadius;
  }
}
