import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/features/enterprise_structure/presentation/widgets/manage_enterprise_structure/manage_enterprise_structure_widgets/org_tree/widgets/org_tree_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class OrgTreeSkeleton extends StatelessWidget {
  final bool isDark;

  const OrgTreeSkeleton({super.key, required this.isDark});

  static const _rows = [
    (indent: 0.0, nameWidth: 0.55, codeWidth: 0.18),
    (indent: 24.0, nameWidth: 0.42, codeWidth: 0.15),
    (indent: 48.0, nameWidth: 0.35, codeWidth: 0.12),
    (indent: 24.0, nameWidth: 0.48, codeWidth: 0.16),
    (indent: 0.0, nameWidth: 0.50, codeWidth: 0.17),
  ];

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OrgTreeHeader(onExpandAll: () {}, onCollapseAll: () {}, isDark: isDark),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: _rows.map((row) {
                return _SkeletonNodeRow(
                  indent: row.indent.w,
                  nameWidthFactor: row.nameWidth,
                  codeWidthFactor: row.codeWidth,
                  isDark: isDark,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonNodeRow extends StatelessWidget {
  const _SkeletonNodeRow({
    required this.indent,
    required this.nameWidthFactor,
    required this.codeWidthFactor,
    required this.isDark,
  });

  final double indent;
  final double nameWidthFactor;
  final double codeWidthFactor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final shimmerColor = isDark ? AppColors.cardBackgroundGreyDark : AppColors.tableHeaderBackground;

    return Padding(
      padding: EdgeInsets.only(left: indent, bottom: 12.h),
      child: Row(
        children: [
          // expand chevron placeholder
          Container(
            width: 24.w,
            height: 24.w,
            decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4.r)),
          ),
          Gap(8.w),
          // icon placeholder
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4.r)),
          ),
          Gap(8.w),
          // name bar — takes remaining space up to nameWidthFactor of screen
          Flexible(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                return Row(
                  children: [
                    Container(
                      width: maxWidth * nameWidthFactor,
                      height: 14.h,
                      decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(4.r)),
                    ),
                    Gap(8.w),
                    Container(
                      width: maxWidth * codeWidthFactor,
                      height: 22.h,
                      decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(6.r)),
                    ),
                    Gap(8.w),
                    Container(
                      width: maxWidth * 0.14,
                      height: 22.h,
                      decoration: BoxDecoration(color: shimmerColor, borderRadius: BorderRadius.circular(6.r)),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
