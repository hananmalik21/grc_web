import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/services/responsive_service.dart';
import 'package:grc/features/security_manager/domain/models/active_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ActiveSessionsDistributionSection extends StatelessWidget {
  final bool isDark;
  final List<ActiveSession> sessions;

  const ActiveSessionsDistributionSection({super.key, required this.isDark, required this.sessions});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveHelper.isMobile(context);
    final fixedCardHeight = isMobile ? null : 180.h;

    final browserCounts = <String, int>{};
    final deviceCounts = <String, int>{};
    final cityCounts = <String, int>{};

    for (final s in sessions) {
      browserCounts.update(s.browser, (v) => v + 1, ifAbsent: () => 1);
      deviceCounts.update(s.deviceType, (v) => v + 1, ifAbsent: () => 1);
      cityCounts.update(s.city, (v) => v + 1, ifAbsent: () => 1);
    }

    final browserItems = _sorted(browserCounts);
    final deviceItems = _sorted(deviceCounts);
    final cityItems = _sorted(cityCounts);
    final browserDisplayItems = [
      ...browserItems,
      if (browserItems.isNotEmpty && browserItems.first.key != 'Firefox') MapEntry('Firefox', browserItems.first.value),
    ];

    final cards = [
      _DistributionCard(
        title: 'Browser Distribution',
        isDark: isDark,
        height: fixedCardHeight,
        child: _BarsList(items: browserDisplayItems, total: sessions.length, barColor: AppColors.primary),
      ),
      _DistributionCard(
        title: 'Device Types',
        isDark: isDark,
        height: fixedCardHeight,
        child: _BarsList(items: deviceItems, total: sessions.length, barColor: AppColors.success),
      ),
      _DistributionCard(
        title: 'Geographic Distribution',
        isDark: isDark,
        height: fixedCardHeight,
        child: _BarsList(items: cityItems, total: sessions.length, barColor: AppColors.info),
      ),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(bottom: i < cards.length - 1 ? 12.h : 0),
              child: cards[i],
            ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < cards.length; i++)
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: i < cards.length - 1 ? 14.w : 0),
              child: cards[i],
            ),
          ),
      ],
    );
  }

  List<MapEntry<String, int>> _sorted(Map<String, int> map) {
    final list = map.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return list;
  }
}

class _DistributionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool isDark;
  final double? height;

  const _DistributionCard({required this.title, required this.child, required this.isDark, this.height});

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: EdgeInsets.all(21.w),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder, width: 1),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: context.textTheme.titleSmall?.copyWith(
              fontSize: 16.sp,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Gap(12.h),
          if (height != null)
            Expanded(
              child: SingleChildScrollView(physics: const NeverScrollableScrollPhysics(), child: child),
            )
          else
            child,
        ],
      ),
    );

    return height == null ? card : SizedBox(height: height, child: card);
  }
}

class _BarsList extends StatelessWidget {
  final List<MapEntry<String, int>> items;
  final int total;
  final Color barColor;

  const _BarsList({required this.items, required this.total, required this.barColor});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty || total == 0) {
      return Text('No sessions', style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary));
    }

    return Column(
      children: items
          .map(
            (e) => Padding(
              padding: EdgeInsetsDirectional.only(bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.key, style: context.textTheme.titleSmall),
                      Text(
                        '${e.value} sessions',
                        style: context.textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  Gap(8.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999.r),
                    child: LinearProgressIndicator(
                      value: e.value / total,
                      minHeight: 7.h,
                      backgroundColor: AppColors.grayBg,
                      valueColor: AlwaysStoppedAnimation<Color>(barColor),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
