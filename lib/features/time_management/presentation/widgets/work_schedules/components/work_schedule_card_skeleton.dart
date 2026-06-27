import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:gap/gap.dart';

class WorkScheduleCardSkeleton extends StatelessWidget {
  const WorkScheduleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final padding = ResponsiveHelper.getCardPadding(context);
    final skeletonColor = isDark ? null : Colors.grey[300];

    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header skeleton
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 18.h,
                          width: 200.w,
                          decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4.r)),
                        ),
                        Gap(4.h),
                        Container(
                          height: 14.h,
                          width: 150.w,
                          decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4.r)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 24.h,
                    width: 60.w,
                    decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(12.r)),
                  ),
                ],
              ),
              Gap(16.h),
              // Content skeleton
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                  Gap(16.w),
                  Expanded(
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                ],
              ),
              Gap(16.h),
              // Weekly schedule skeleton
              Container(
                height: 14.h,
                width: 120.w,
                decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4.r)),
              ),
              Gap(8.h),
              Row(
                children: List.generate(
                  7,
                  (index) => Expanded(
                    child: Container(
                      height: 52.h,
                      margin: EdgeInsets.only(right: index < 6 ? 8.w : 0),
                      decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(4.r)),
                    ),
                  ),
                ),
              ),
              Gap(16.h),
              // Actions skeleton
              Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder)),
                ),
                padding: EdgeInsets.only(top: 17.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                    Gap(8.w),
                    Expanded(
                      child: Container(
                        height: 36.h,
                        decoration: BoxDecoration(color: skeletonColor, borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
