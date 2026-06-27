import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ComponentsChartSkeletonLoader extends StatelessWidget {
  final bool isPie;

  const ComponentsChartSkeletonLoader({super.key, this.isPie = false});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AspectRatio(aspectRatio: 1, child: isPie ? _buildPieSkeleton() : _buildBarSkeleton()),
          ),
          Gap(16.w),
          Expanded(flex: 2, child: _buildLegendSkeleton()),
        ],
      ),
    );
  }

  Widget _buildPieSkeleton() {
    return Center(
      child: Container(
        width: 150.w,
        height: 150.w,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildBarSkeleton() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (index) {
          final heights = [60.0, 40.0, 50.0];
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 48.w,
                height: heights[index].h,
                decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(4.r)),
              ),
              Gap(8.h),
              Container(width: 80.w, height: 12.h, color: Colors.grey[400]),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLegendSkeleton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(
        isPie ? 3 : 2,
        (index) => Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
              ),
              Gap(8.w),
              Expanded(
                child: Container(height: 12.h, color: Colors.grey[400]),
              ),
              Gap(8.w),
              Container(width: 24.w, height: 12.h, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
