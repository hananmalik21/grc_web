import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmploymentTypeSkeleton extends StatelessWidget {
  const EmploymentTypeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildColumn(2)),
              Gap(12.w),
              Expanded(child: _buildColumn(2)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(int count) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => Padding(
          padding: EdgeInsets.only(top: index > 0 ? 12.h : 0),
          child: const DigifyCheckbox(value: false, onChanged: null, label: 'Skeleton Item Name'),
        ),
      ),
    );
  }
}
