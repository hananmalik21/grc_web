import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/localization/l10n/app_localizations.dart';
import 'package:grc/core/services/responsive/responsive_helper.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/assets/digify_asset.dart';
import 'package:grc/features/payroll/presentation/screens/flow_monitor/flow_monitor_tab_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class FlowMonitorStatsSection extends StatefulWidget {
  const FlowMonitorStatsSection({super.key});

  @override
  State<FlowMonitorStatsSection> createState() => _FlowMonitorStatsSectionState();
}

class _FlowMonitorStatsSectionState extends State<FlowMonitorStatsSection> {
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
    final loc = AppLocalizations.of(context)!;
    final cards = FlowMonitorTabConfig.buildStatCards(loc: loc);
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
            for (var index = 0; index < cards.length; index++) ...[
              SizedBox(
                width: cardWidth,
                child: _FlowMonitorStatCard(data: cards[index]),
              ),
              if (index < cards.length - 1) Gap(spacing),
            ],
          ],
        ),
      ),
    );
  }
}

class _FlowMonitorStatCard extends StatelessWidget {
  const _FlowMonitorStatCard({required this.data});

  final FlowMonitorStatCardData data;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 21.w, vertical: 19.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: context.textTheme.bodySmall?.copyWith(
                    fontSize: 13.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ),
              Container(
                width: 34.w,
                height: 34.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.infoBgDark.withValues(alpha: 0.22) : AppColors.infoBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                alignment: Alignment.center,
                child: DigifyAsset(assetPath: data.iconPath, width: 20, height: 20, color: AppColors.primary),
              ),
            ],
          ),
          Gap(10.h),
          Text(
            data.value,
            style: context.textTheme.titleLarge?.copyWith(
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
