import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class WorkforcePositionsListMobileSkeleton extends StatelessWidget {
  const WorkforcePositionsListMobileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
        itemCount: 6,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, _) => const _PositionCardSkeleton(),
      ),
    );
  }
}

class _PositionCardSkeleton extends StatelessWidget {
  const _PositionCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.dashboardCardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 180.w,
            height: 14.h,
            decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(6.r)),
          ),
          Gap(6.h),
          Container(
            width: 100.w,
            height: 12.h,
            decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(6.r)),
          ),
          Gap(10.h),
          Row(
            children: [
              const Spacer(),
              Container(
                width: 70.w,
                height: 24.h,
                decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(999.r)),
              ),
            ],
          ),
          Gap(10.h),
          const DigifyDivider.thin(),
          Gap(10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: List.generate(
              3,
              (_) => Padding(
                padding: EdgeInsetsDirectional.only(start: 8.w),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(color: AppColors.cardBorder, borderRadius: BorderRadius.circular(10.r)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
