import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftCardSkeleton extends StatefulWidget {
  const ShiftCardSkeleton({super.key});

  @override
  State<ShiftCardSkeleton> createState() => _ShiftCardSkeletonState();
}

class _ShiftCardSkeletonState extends State<ShiftCardSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.3, end: 0.7).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardBackgroundDark : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSkeletonCircle(36.w, isDark),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSkeletonBox(
                                width: 120.w,
                                height: 14.h,
                                isDark: isDark,
                              ),
                              SizedBox(height: 6.h),
                              _buildSkeletonBox(
                                width: 90.w,
                                height: 12.h,
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),
                        _buildSkeletonBox(
                          width: 60.w,
                          height: 24.h,
                          isDark: isDark,
                          borderRadius: 12.r,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    _buildSkeletonBox(
                      width: 80.w,
                      height: 20.h,
                      isDark: isDark,
                      borderRadius: 4.r,
                    ),
                    SizedBox(height: 16.h),
                    _buildDetailRowSkeleton(isDark),
                    SizedBox(height: 8.h),
                    _buildDetailRowSkeleton(isDark),
                    SizedBox(height: 8.h),
                    _buildDetailRowSkeleton(isDark),
                    SizedBox(height: 8.h),
                    _buildDetailRowSkeleton(isDark),
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Divider(
                  height: 1,
                  color: isDark
                      ? AppColors.cardBorderDark
                      : AppColors.cardBorder,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSkeletonBox(
                        height: 32.h,
                        isDark: isDark,
                        borderRadius: 8.r,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _buildSkeletonBox(
                        height: 32.h,
                        isDark: isDark,
                        borderRadius: 8.r,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    _buildSkeletonBox(
                      width: 40.w,
                      height: 32.h,
                      isDark: isDark,
                      borderRadius: 8.r,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRowSkeleton(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildSkeletonBox(width: 60.w, height: 12.h, isDark: isDark),
        _buildSkeletonBox(width: 100.w, height: 12.h, isDark: isDark),
      ],
    );
  }

  Widget _buildSkeletonBox({
    double? width,
    required double height,
    required bool isDark,
    double? borderRadius,
  }) {
    final baseColor = isDark
        ? AppColors.cardBackgroundGreyDark
        : AppColors.cardBackgroundGrey;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: _animation.value),
        borderRadius: BorderRadius.circular(borderRadius ?? 4.r),
      ),
    );
  }

  Widget _buildSkeletonCircle(double size, bool isDark) {
    final baseColor = isDark
        ? AppColors.cardBackgroundGreyDark
        : AppColors.cardBackgroundGrey;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: baseColor.withValues(alpha: _animation.value),
        shape: BoxShape.circle,
      ),
    );
  }
}
