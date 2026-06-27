import 'package:grc/core/services/responsive/responsive_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/theme/theme_extensions.dart';
import '../../../../../core/widgets/assets/digify_asset.dart';
import '../../providers/grade_structure_management/grade_structure_managment_provider.dart';

class ComponentGradeStructureStats extends ConsumerWidget {
  const ComponentGradeStructureStats({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gradeStructureManagementProvider);
    final stats = state.stats ?? [];

    if (stats.isEmpty) return const SizedBox.shrink();

    final isMobile = context.isMobile;

    if (isMobile) {
      return Wrap(
        spacing: 16.w,
        runSpacing: 16.h,
        children: stats
            .map(
              (stat) => SizedBox(
                width: (context.deviceWidth - 64.w) / 2,
                child: GradeStructureStatCard(stat: stat),
              ),
            )
            .toList(),
      );
    }

    return Row(
      children: stats
          .map(
            (stat) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: stat == stats.last ? 0 : 16.w),
                child: GradeStructureStatCard(stat: stat),
              ),
            ),
          )
          .toList(),
    );
  }
}

class GradeStructureStatCard extends StatelessWidget {
  const GradeStructureStatCard({super.key, required this.stat});
  final GradeStructureStat stat;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            stat.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textTheme.labelLarge?.copyWith(
              color: isDark
                  ? AppColors.textSecondaryDark
                  : const Color(0xFF4A5565),
              fontWeight: FontWeight.w500,
            ),
          ),
          Gap(8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stat.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.headlineLarge?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : const Color(0xFF0F172B),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (stat.subTitle.isNotEmpty) ...[
                      Gap(4.h),
                      Text(
                        stat.subTitle,
                        style: context.textTheme.labelSmall?.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  color: stat.iconBackground,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                alignment: Alignment.center,
                child: DigifyAsset(
                  assetPath: stat.icon,
                  color: stat.iconColor,
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
