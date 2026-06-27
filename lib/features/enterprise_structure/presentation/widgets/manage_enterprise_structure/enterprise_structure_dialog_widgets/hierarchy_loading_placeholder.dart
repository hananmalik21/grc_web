import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/widgets/common/app_loading_indicator.dart';
import 'package:grc/core/widgets/feedback/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'shimmer_loading_widget.dart';

class HierarchyLoadingPlaceholder extends StatelessWidget {
  final bool isDark;

  const HierarchyLoadingPlaceholder({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) => Opacity(opacity: value, child: child!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 24.r,
                height: 24.r,
                child: AppLoadingIndicator(type: LoadingType.fadingCircle, size: 24.r),
              ),
              Gap(12.w),
              Text(
                'Loading hierarchy levels...',
                style: TextStyle(fontSize: 14.sp, color: textColor, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          Gap(20.h),
          const ShimmerLoadingWidget(),
          Gap(24.h),
          const _PreviewShimmer(),
          Gap(24.h),
          _SummaryShimmer(isDark: isDark),
        ],
      ),
    );
  }
}

class _PreviewShimmer extends StatelessWidget {
  const _PreviewShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(width: 140.w, height: 18.h, borderRadius: 4.r),
        Gap(16.h),
        ...List.generate(5, (i) {
          final width = 400.w - (i * 24.w);
          return Padding(
            padding: EdgeInsetsDirectional.only(bottom: 8.h),
            child: ShimmerContainer(width: width, height: 44.h, borderRadius: 8.r),
          );
        }),
      ],
    );
  }
}

class _SummaryShimmer extends StatelessWidget {
  final bool isDark;

  const _SummaryShimmer({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.all(16.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.infoBg,
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.infoBorder, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerContainer(width: 180.w, height: 18.h, borderRadius: 4.r),
          Gap(12.h),
          ShimmerContainer(width: double.infinity, height: 16.h, borderRadius: 4.r),
          Gap(8.h),
          ShimmerContainer(width: 220.w, height: 16.h, borderRadius: 4.r),
          Gap(8.h),
          ShimmerContainer(width: 160.w, height: 16.h, borderRadius: 4.r),
        ],
      ),
    );
  }
}
