import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/core/widgets/common/digify_error_state.dart';
import 'package:grc/features/time_management/presentation/providers/time_management_stats_providers.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TimeManagementStatsCards extends ConsumerStatefulWidget {
  final AppLocalizations localizations;
  final bool isDark;

  const TimeManagementStatsCards({super.key, required this.localizations, required this.isDark});

  @override
  ConsumerState<TimeManagementStatsCards> createState() => _TimeManagementStatsCardsState();
}

class _TimeManagementStatsCardsState extends ConsumerState<TimeManagementStatsCards> {
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
    final statsAsync = ref.watch(timeManagementStatsNotifierProvider);

    if (statsAsync.hasError) {
      return DigifyErrorState(
        message: 'Failed to load time management statistics',
        onRetry: () => ref.read(timeManagementStatsNotifierProvider.notifier).refresh(),
      );
    }

    final stats = statsAsync.valueOrNull;
    final isLoading = statsAsync.isLoading;

    final cards = [
      _StatCardData(
        label: widget.localizations.shifts,
        value: stats?.formattedTotalShifts ?? '0',
        iconPath: Assets.icons.clockIcon.path,
      ),
      _StatCardData(
        label: widget.localizations.workPatterns,
        value: stats?.formattedTotalWorkPatterns ?? '0',
        iconPath: Assets.icons.leaveManagementIcon.path,
      ),
      _StatCardData(
        label: widget.localizations.workSchedules,
        value: stats?.formattedTotalWorkSchedules ?? '0',
        iconPath: Assets.icons.sidebar.workSchedules.path,
      ),
      _StatCardData(
        label: widget.localizations.scheduleAssignments,
        value: stats?.formattedTotalScheduleAssignments ?? '0',
        iconPath: Assets.icons.sidebar.scheduleAssignments.path,
      ),
    ];

    final cardWidth = ResponsiveHelper.getResponsiveWidth(context, mobile: 220, tablet: 236, web: 252);
    final spacing = ResponsiveHelper.getResponsiveWidth(context, mobile: 12, tablet: 16, web: 20);

    return Skeletonizer(
      enabled: isLoading,
      child: Scrollbar(
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
              for (var i = 0; i < cards.length; i++) ...[
                SizedBox(
                  width: cardWidth,
                  child: _TimeManagementStatCard(data: cards[i]),
                ),
                if (i < cards.length - 1) Gap(spacing),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCardData {
  final String label;
  final String value;
  final String iconPath;

  const _StatCardData({required this.label, required this.value, required this.iconPath});
}

class _TimeManagementStatCard extends StatelessWidget {
  final _StatCardData data;

  const _TimeManagementStatCard({required this.data});

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
                  data.label,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                Gap(6.h),
                Text(
                  data.value,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Gap(12.w),
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.22) : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: DigifyAsset(assetPath: data.iconPath, width: 20, height: 20, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
