import 'dart:ui';

import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardBackground extends StatelessWidget {
  final bool isDark;

  const DashboardBackground({super.key, required this.isDark});

  Widget _circle({required double width, required double height, required List<Color> colors}) {
    return SizedBox(
      width: width,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.0, 0.5, 1.0],
          colors: isDark
              ? [AppColors.cardBackgroundGreyDark, AppColors.infoBgDark, AppColors.cardBackgroundGreyDark]
              : [
                  AppColors.dashboardBgGradientStart,
                  AppColors.dashboardBgGradientMid,
                  AppColors.dashboardBgGradientEnd,
                ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: _circle(
              width: 336.w,
              height: 336.h,
              colors: [
                AppColors.dashboardCircleBlue.withValues(alpha: 0.3),
                AppColors.dashboardCirclePurple.withValues(alpha: 0.3),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: _circle(
              width: 336.w,
              height: 336.h,
              colors: [
                AppColors.dashboardCirclePink.withValues(alpha: 0.3),
                AppColors.dashboardCircleOrange.withValues(alpha: 0.3),
              ],
            ),
          ),
          Positioned.fill(
            child: Center(
              child: _circle(
                width: 336.w,
                height: 336.h,
                colors: [
                  AppColors.dashboardCircleGreen.withValues(alpha: 0.3),
                  AppColors.dashboardCircleCyan.withValues(alpha: 0.3),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  color: (isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground).withValues(
                    alpha: isDark ? 0.3 : 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
