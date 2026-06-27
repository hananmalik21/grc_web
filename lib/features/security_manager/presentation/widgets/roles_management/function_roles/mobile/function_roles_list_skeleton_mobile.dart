import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// Loading placeholders matching [FunctionRoleCardMobile] layout.
class FunctionRolesListSkeletonMobile extends StatelessWidget {
  const FunctionRolesListSkeletonMobile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Skeletonizer(
      enabled: true,
      child: Column(
        children: [
          for (int i = 0; i < 3; i++) ...[_SkeletonCard(isDark: isDark), if (i != 2) Gap(12.h)],
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Bone.circle(size: 40.w),
              Gap(12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Bone.text(words: 2), Gap(8.h), Bone.text(words: 3)],
                ),
              ),
            ],
          ),
          Gap(12.h),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: Bone.button(width: 72.w, height: 28.h),
          ),
        ],
      ),
    );
  }
}
