import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/feedback/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for structure card
class StructureCardShimmer extends StatelessWidget {
  const StructureCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(18.w),
        tablet: EdgeInsetsDirectional.all(22.w),
        web: EdgeInsetsDirectional.all(26.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : const Color(0xFFE5E7EB),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: isMobile
          ? _buildMobileShimmer(isDark, isTablet)
          : _buildDesktopShimmer(isDark, isTablet),
    );
  }

  Widget _buildMobileShimmer(bool isDark, bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and status badge row
        Row(
          children: [
            Expanded(
              child: ShimmerContainer(
                width: double.infinity,
                height: 17.4.sp,
                borderRadius: 4.r,
              ),
            ),
            SizedBox(width: 12.w),
            ShimmerContainer(width: 60.w, height: 24.h, borderRadius: 9999.r),
          ],
        ),
        SizedBox(height: 8.h),
        // Description
        ShimmerContainer(
          width: double.infinity,
          height: 15.3.sp,
          borderRadius: 4.r,
        ),
        SizedBox(height: 4.h),
        ShimmerContainer(width: 200.w, height: 15.3.sp, borderRadius: 4.r),
        SizedBox(height: 8.h),
        // Hierarchy levels
        Row(
          children: [
            ShimmerContainer(width: 80.w, height: 20.h, borderRadius: 4.r),
            SizedBox(width: 8.w),
            ShimmerContainer(width: 100.w, height: 20.h, borderRadius: 4.r),
            SizedBox(width: 8.w),
            ShimmerContainer(width: 70.w, height: 20.h, borderRadius: 4.r),
          ],
        ),
        SizedBox(height: 8.h),
        // Metrics
        Row(
          children: [
            ShimmerContainer(width: 60.w, height: 20.h, borderRadius: 4.r),
            SizedBox(width: 8.w),
            ShimmerContainer(width: 4.w, height: 20.h, borderRadius: 2.r),
            SizedBox(width: 8.w),
            ShimmerContainer(width: 80.w, height: 20.h, borderRadius: 4.r),
            SizedBox(width: 8.w),
            ShimmerContainer(width: 4.w, height: 20.h, borderRadius: 2.r),
            SizedBox(width: 8.w),
            ShimmerContainer(width: 90.w, height: 20.h, borderRadius: 4.r),
          ],
        ),
        SizedBox(height: 16.h),
        // Action buttons
        Column(
          children: [
            ShimmerContainer(
              width: double.infinity,
              height: 40.h,
              borderRadius: 10.r,
            ),
            SizedBox(height: 8.h),
            ShimmerContainer(
              width: double.infinity,
              height: 40.h,
              borderRadius: 10.r,
            ),
            SizedBox(height: 8.h),
            ShimmerContainer(
              width: double.infinity,
              height: 40.h,
              borderRadius: 10.r,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopShimmer(bool isDark, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and status badge row
              Row(
                children: [
                  Flexible(
                    child: ShimmerContainer(
                      width: 300.w,
                      height: isTablet ? 16.sp : 17.4.sp,
                      borderRadius: 4.r,
                    ),
                  ),
                  SizedBox(width: isTablet ? 10.w : 12.w),
                  ShimmerContainer(
                    width: 60.w,
                    height: 24.h,
                    borderRadius: 9999.r,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Description
              ShimmerContainer(
                width: 400.w,
                height: isTablet ? 13.5.sp : 15.3.sp,
                borderRadius: 4.r,
              ),
              SizedBox(height: 4.h),
              ShimmerContainer(
                width: 300.w,
                height: isTablet ? 13.5.sp : 15.3.sp,
                borderRadius: 4.r,
              ),
              SizedBox(height: 12.h),
              // Hierarchy levels
              Row(
                children: [
                  ShimmerContainer(
                    width: 80.w,
                    height: 20.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(width: 8.w),
                  ShimmerContainer(
                    width: 100.w,
                    height: 20.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(width: 8.w),
                  ShimmerContainer(
                    width: 70.w,
                    height: 20.h,
                    borderRadius: 4.r,
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              // Metrics
              Row(
                children: [
                  ShimmerContainer(
                    width: 60.w,
                    height: 20.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(width: 8.w),
                  ShimmerContainer(width: 4.w, height: 20.h, borderRadius: 2.r),
                  SizedBox(width: 8.w),
                  ShimmerContainer(
                    width: 80.w,
                    height: 20.h,
                    borderRadius: 4.r,
                  ),
                  SizedBox(width: 8.w),
                  ShimmerContainer(width: 4.w, height: 20.h, borderRadius: 2.r),
                  SizedBox(width: 8.w),
                  ShimmerContainer(
                    width: 90.w,
                    height: 20.h,
                    borderRadius: 4.r,
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: isTablet ? 16.w : 24.w),
        // Action buttons column
        Column(
          children: [
            ShimmerContainer(
              width: isTablet ? 120.w : 140.w,
              height: 40.h,
              borderRadius: 10.r,
            ),
            SizedBox(height: 8.h),
            ShimmerContainer(
              width: isTablet ? 120.w : 140.w,
              height: 40.h,
              borderRadius: 10.r,
            ),
            SizedBox(height: 8.h),
            ShimmerContainer(
              width: isTablet ? 120.w : 140.w,
              height: 40.h,
              borderRadius: 10.r,
            ),
          ],
        ),
      ],
    );
  }
}
