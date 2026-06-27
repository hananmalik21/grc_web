import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PublicHolidaysSkeleton extends StatelessWidget {
  final int groupCount;
  final int holidaysPerGroup;

  const PublicHolidaysSkeleton({super.key, this.groupCount = 3, this.holidaysPerGroup = 2});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          groupCount,
          (groupIndex) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGroupSkeleton(context, isDark, holidaysPerGroup),
              if (groupIndex < groupCount - 1)
                Gap(ResponsiveHelper.getResponsiveHeight(context, mobile: 16, tablet: 24, web: 24)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGroupSkeleton(BuildContext context, bool isDark, int holidayCount) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), offset: const Offset(0, 4), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardBackgroundDark : const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(12.r), topRight: Radius.circular(12.r)),
            ),
            child: Container(
              height: 24.h,
              width: 150.w,
              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              children: List.generate(
                holidayCount,
                (index) => Column(
                  children: [
                    _buildHolidayCardSkeleton(isDark),
                    if (index < holidayCount - 1) ...[
                      Gap(16.h),
                      Container(height: 1, color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
                      Gap(16.h),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHolidayCardSkeleton(bool isDark) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 64.w,
            height: 64.h,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r)),
          ),
          Gap(16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 20.h,
                  width: 200.w,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                ),
                Gap(8.h),
                Container(
                  height: 16.h,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                ),
                Gap(4.h),
                Container(
                  height: 16.h,
                  width: 150.w,
                  decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                ),
                Gap(12.h),
                Row(
                  children: [
                    Container(
                      height: 14.h,
                      width: 100.w,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                    ),
                    Gap(16.w),
                    Container(
                      height: 14.h,
                      width: 80.w,
                      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Gap(12.w),
          Row(
            children: [
              Container(
                width: 18.w,
                height: 18.h,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
              ),
              Gap(8.w),
              Container(
                width: 18.w,
                height: 18.h,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
              ),
              Gap(8.w),
              Container(
                width: 18.w,
                height: 18.h,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
