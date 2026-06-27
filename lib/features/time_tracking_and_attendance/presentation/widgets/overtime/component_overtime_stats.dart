import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime/overtime_management.dart';
import 'package:grc/features/time_tracking_and_attendance/presentation/providers/overtime/overtime_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ComponentOvertimeStats extends ConsumerStatefulWidget {
  const ComponentOvertimeStats({super.key});

  @override
  ConsumerState<ComponentOvertimeStats> createState() => _ComponentOvertimeStatsState();
}

class _ComponentOvertimeStatsState extends ConsumerState<ComponentOvertimeStats> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(overtimeManagementProvider);
    final stats = state.stats ?? [];

    if (stats.isEmpty) return const SizedBox.shrink();

    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 12.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              SizedBox(
                width: cardWidth,
                child: OvertimeStatCard(stat: stats[i]),
              ),
              if (i < stats.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}

class OvertimeStatCard extends StatelessWidget {
  const OvertimeStatCard({super.key, required this.stat});
  final OvertimeStat stat;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  stat.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                Gap(6.h),
                Text(
                  stat.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
                if (stat.subTitle.isNotEmpty) ...[
                  Gap(4.h),
                  Text(
                    stat.subTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Gap(12.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(color: stat.iconBackground, borderRadius: BorderRadius.circular(10.r)),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: stat.icon, color: stat.iconColor, width: 20, height: 20),
          ),
        ],
      ),
    );
  }
}
