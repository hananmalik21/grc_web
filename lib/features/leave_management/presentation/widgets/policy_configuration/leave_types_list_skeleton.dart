import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/constants/app_gradients.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class LeaveTypesListSkeleton extends StatelessWidget {
  final bool isDark;
  final int itemCount;

  const LeaveTypesListSkeleton({super.key, required this.isDark, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
          boxShadow: AppShadows.primaryShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                gradient: AppGradients.primaryHorizontal,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.r), topRight: Radius.circular(10.r)),
              ),
              child: Row(
                children: [
                  Container(
                    height: 16.h,
                    width: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(
              itemCount,
              (index) => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 7.h,
                            children: [
                              Container(
                                height: 14.h,
                                width: 140.w,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              Container(
                                height: 12.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                              ),
                              Wrap(
                                spacing: 7.w,
                                runSpacing: 4.h,
                                children: [
                                  Container(
                                    height: 20.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                  Container(
                                    height: 20.h,
                                    width: 45.w,
                                    decoration: BoxDecoration(
                                      color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                                      borderRadius: BorderRadius.circular(4.r),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Container(
                          width: 14.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < itemCount - 1) DigifyDivider.horizontal(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
