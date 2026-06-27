import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OvertimeListSkeleton extends StatelessWidget {
  const OvertimeListSkeleton({super.key, required this.isDark, required this.isLoading});

  final bool isDark;
  final bool isLoading;

  Widget _skeletonCard() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F1F1F) : const Color(0xFFF6F7F9),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFE6E6E6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(color: Colors.grey[300], shape: BoxShape.circle),
              ),
              Gap(10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 12.h, width: 0.5.sw, color: Colors.grey[300]),
                    Gap(6.h),
                    Container(height: 10.h, width: 0.3.sw, color: Colors.grey[200]),
                  ],
                ),
              ),
            ],
          ),
          Gap(12.h),
          Container(height: 10.h, width: 0.9.sw, color: Colors.grey[200]),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Skeletonizer(
      enabled: true,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        itemCount: 6,
        separatorBuilder: (_, _) => Gap(10.h),
        itemBuilder: (_, _) => _skeletonCard(),
      ),
    );
  }
}
