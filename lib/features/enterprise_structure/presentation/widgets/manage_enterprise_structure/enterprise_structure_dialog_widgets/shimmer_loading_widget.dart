import 'package:grc/core/widgets/feedback/shimmer_widget.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/shared/hierarchy_level_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerContainer(width: 200.w, height: 20.h, borderRadius: 4.r),
        Gap(16.h),
        ...List.generate(
          5,
          (index) => Padding(
            padding: EdgeInsetsDirectional.only(bottom: 12.h),
            child: const HierarchyLevelShimmer(),
          ),
        ),
      ],
    );
  }
}
