import 'package:grc/core/widgets/common/digify_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EmployeeCategorySkeleton extends StatelessWidget {
  const EmployeeCategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Row(
        children: List.generate(
          3,
          (index) => Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(start: index > 0 ? 16.w : 0),
              child: const DigifyCheckbox(value: false, onChanged: null, label: 'Skeleton Item Name'),
            ),
          ),
        ),
      ),
    );
  }
}
