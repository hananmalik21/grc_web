import 'package:grc/features/enterprise_structure/presentation/widgets/shared/structure_card_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StructuresListSkeleton extends StatelessWidget {
  final int itemCount;

  const StructuresListSkeleton({super.key, this.itemCount = 3});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < itemCount; i++) ...[if (i > 0) Gap(16.h), const StructureCardShimmer()],
      ],
    );
  }
}
