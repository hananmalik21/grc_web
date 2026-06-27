import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/time_management/presentation/widgets/shifts/components/shift_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShiftsGridSkeleton extends StatelessWidget {
  final int itemCount;

  const ShiftsGridSkeleton({super.key, this.itemCount = 6});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: ResponsiveHelper.getGridColumns(context),
        mainAxisSpacing: 20.h,
        crossAxisSpacing: 20.w,
        mainAxisExtent: ResponsiveHelper.getShiftCardExtent(context),
      ),
      itemBuilder: (context, index) {
        return const ShiftCardSkeleton();
      },
    );
  }
}
