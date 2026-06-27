import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CreateRequisitionOrgStructureFieldsSkeleton extends StatelessWidget {
  const CreateRequisitionOrgStructureFieldsSkeleton({super.key, this.levelCount = 3});

  final int levelCount;

  @override
  Widget build(BuildContext context) {
    final bone = _boneColor(context);
    final border = _borderColor(context);
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var i = 0; i < levelCount; i++) ...[
            if (i > 0) Gap(12.h),
            _OrgLevelFieldBone(boneColor: bone, borderColor: border),
          ],
        ],
      ),
    );
  }

  Color _boneColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? AppColors.cardBackgroundGreyDark
        : AppColors.cardBackgroundGrey;
  }

  Color _borderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? AppColors.borderGreyDark : AppColors.borderGrey;
  }
}

class _OrgLevelFieldBone extends StatelessWidget {
  const _OrgLevelFieldBone({required this.boneColor, required this.borderColor});

  final Color boneColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120.w,
          height: 14.h,
          decoration: BoxDecoration(color: boneColor, borderRadius: BorderRadius.circular(4.r)),
        ),
        Gap(6.h),
        Container(
          width: double.infinity,
          height: 40.w,
          decoration: BoxDecoration(color: boneColor, borderRadius: BorderRadius.circular(10.r)),
        ),
      ],
    );
  }
}
