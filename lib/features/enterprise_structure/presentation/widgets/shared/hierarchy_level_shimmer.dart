import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/core/widgets/feedback/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Shimmer skeleton for hierarchy level card
class HierarchyLevelShimmer extends StatelessWidget {
  const HierarchyLevelShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final isMobile = ResponsiveHelper.isMobile(context);
    final isTablet = ResponsiveHelper.isTablet(context);

    return Container(
      padding: ResponsiveHelper.getResponsivePadding(
        context,
        mobile: EdgeInsetsDirectional.all(12.w),
        tablet: EdgeInsetsDirectional.all(15.w),
        web: EdgeInsetsDirectional.all(18.w),
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.successBgDark : const Color(0xFFF0FDF4),
        border: Border.all(
          color: isDark ? AppColors.successBorderDark : const Color(0xFFB9F8CF),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ShimmerContainer(
                      width: 28.w,
                      height: 28.h,
                      borderRadius: 10.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ShimmerContainer(
                                width: 80.w,
                                height: 16.h,
                                borderRadius: 4.r,
                              ),
                              SizedBox(width: 6.w),
                              ShimmerContainer(
                                width: 60.w,
                                height: 20.h,
                                borderRadius: 4.r,
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          ShimmerContainer(
                            width: 120.w,
                            height: 12.h,
                            borderRadius: 4.r,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ShimmerContainer(
                          width: 18.w,
                          height: 18.h,
                          borderRadius: 4.r,
                        ),
                        SizedBox(width: 8.w),
                        ShimmerContainer(
                          width: 18.w,
                          height: 18.h,
                          borderRadius: 4.r,
                        ),
                      ],
                    ),
                    ShimmerContainer(
                      width: 50.w,
                      height: 28.h,
                      borderRadius: 9999.r,
                    ),
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      ShimmerContainer(
                        width: isTablet ? 30.w : 32.w,
                        height: isTablet ? 30.h : 32.h,
                        borderRadius: 10.r,
                      ),
                      SizedBox(width: isTablet ? 6.w : 8.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ShimmerContainer(
                                  width: 100.w,
                                  height: isTablet ? 16.h : 18.h,
                                  borderRadius: 4.r,
                                ),
                                SizedBox(width: isTablet ? 6.w : 8.w),
                                ShimmerContainer(
                                  width: 70.w,
                                  height: isTablet ? 22.h : 24.h,
                                  borderRadius: 4.r,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            ShimmerContainer(
                              width: 150.w,
                              height: isTablet ? 14.h : 16.h,
                              borderRadius: 4.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: isTablet ? 6.w : 8.w),
                Column(
                  children: [
                    ShimmerContainer(
                      width: isTablet ? 15.w : 16.w,
                      height: isTablet ? 15.h : 16.h,
                      borderRadius: 4.r,
                    ),
                    SizedBox(height: 4.h),
                    ShimmerContainer(
                      width: isTablet ? 15.w : 16.w,
                      height: isTablet ? 15.h : 16.h,
                      borderRadius: 4.r,
                    ),
                  ],
                ),
                SizedBox(width: isTablet ? 6.w : 8.w),
                ShimmerContainer(
                  width: isTablet ? 42.w : 44.w,
                  height: isTablet ? 22.h : 24.h,
                  borderRadius: 9999.r,
                ),
              ],
            ),
    );
  }
}
