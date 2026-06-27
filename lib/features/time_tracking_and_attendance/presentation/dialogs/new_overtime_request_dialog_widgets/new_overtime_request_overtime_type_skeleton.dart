import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NewOvertimeRequestOvertimeTypeSkeleton extends StatelessWidget {
  const NewOvertimeRequestOvertimeTypeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 120.w,
            height: 14.h,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4.r)),
          ),
          Gap(8.h),
          Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10.r)),
          ),
        ],
      ),
    );
  }
}
