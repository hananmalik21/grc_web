import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:grc/gen/assets.gen.dart';

class TimesheetStatsGrid extends StatefulWidget {
  final int total;
  final int draft;
  final int submitted;
  final int approved;
  final int rejected;
  final double regularHours;
  final double overtimeHours;
  final bool isDark;
  final bool isLoading;

  const TimesheetStatsGrid({
    super.key,
    required this.total,
    required this.draft,
    required this.submitted,
    required this.approved,
    required this.rejected,
    required this.regularHours,
    required this.overtimeHours,
    required this.isDark,
    this.isLoading = false,
  });

  @override
  State<TimesheetStatsGrid> createState() => _TimesheetStatsGridState();
}

class _TimesheetStatsGridState extends State<TimesheetStatsGrid> {
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
    final cardWidth = ResponsiveHelper.getResponsiveWidth(
      context,
      mobile: 180,
      tablet: 210,
      web: 236,
    );
    final spacing = ResponsiveHelper.getResponsiveWidth(
      context,
      mobile: 12,
      tablet: 16,
      web: 16,
    );

    final cards = [
      _TimesheetStatCardData(
        title: 'Total',
        value: widget.total.toString(),
        iconPath: Assets.icons.viewIconBlueFigma.path,
      ),
      _TimesheetStatCardData(
        title: 'Draft',
        value: widget.draft.toString(),
        iconPath: Assets.icons.headIcon.path,
      ),
      _TimesheetStatCardData(
        title: 'Submitted',
        value: widget.submitted.toString(),
        iconPath: Assets.icons.submitted.path,
      ),
      _TimesheetStatCardData(
        title: 'Approved',
        value: widget.approved.toString(),
        icon: Icons.check_circle_outline,
      ),
      _TimesheetStatCardData(
        title: 'Rejected',
        value: widget.rejected.toString(),
        icon: Icons.cancel_outlined,
      ),
      _TimesheetStatCardData(
        title: 'Reg. Hours',
        value: '${widget.regularHours.toInt()}h',
        iconPath: Assets.icons.clockIcon.path,
      ),
      _TimesheetStatCardData(
        title: 'OT Hours',
        value: '${widget.overtimeHours.toInt()}h',
        iconPath: Assets.icons.attendance.halfDay.path,
      ),
    ];

    return Skeletonizer(
      enabled: widget.isLoading,
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
                  child: _TimesheetStatCard(data: cards[i], isDark: widget.isDark),
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

class _TimesheetStatCardData {
  final String title;
  final String value;
  final String? iconPath;
  final IconData? icon;

  const _TimesheetStatCardData({
    required this.title,
    required this.value,
    this.iconPath,
    this.icon,
  }) : assert(iconPath != null || icon != null, 'Provide iconPath or icon');
}

class _TimesheetStatCard extends StatelessWidget {
  const _TimesheetStatCard({required this.data, required this.isDark});

  final _TimesheetStatCardData data;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder,
        ),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondary,
                  ),
                ),
                Gap(6.h),
                Text(
                  data.value,
                  style: context.textTheme.titleLarge?.copyWith(
                    fontSize: 20.sp,
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimary,
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
              color: isDark
                  ? AppColors.infoBgDark.withValues(alpha: 0.22)
                  : AppColors.infoBg,
              borderRadius: BorderRadius.circular(10.r),
            ),
            alignment: Alignment.center,
            child: data.iconPath != null
                ? DigifyAsset(
                    assetPath: data.iconPath!,
                    width: 20,
                    height: 20,
                    color: AppColors.primary,
                  )
                : Icon(data.icon, size: 20.sp, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
