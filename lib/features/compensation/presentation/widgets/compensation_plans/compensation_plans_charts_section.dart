import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/app_shadows.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/core/widgets/common/digify_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'charts/compensation_plans_line_chart.dart';
import 'charts/compensation_plans_bar_chart.dart';
import 'charts/compensation_plans_pie_chart.dart';
import 'charts/compensation_plans_insights_alerts.dart';

class CompensationPlansChartsSection extends StatelessWidget {
  const CompensationPlansChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        final children = const [_LineTrendCard(), _StatusDistributionCard(), _PlansByTypeCard(), _InsightsAlertsCard()];

        if (isMobile) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[if (i > 0) Gap(16.h), children[i]],
            ],
          );
        }

        final width = (constraints.maxWidth - 16.w) / 2;
        return Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          children: children.map((child) => SizedBox(width: width, child: child)).toList(),
        );
      },
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final Widget child;

  const _DashboardCard({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardBackgroundDark : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
        boxShadow: AppShadows.primaryShadow,
      ),
      child: child,
    );
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return _DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: context.textTheme.titleSmall?.copyWith(fontSize: 18.sp)),
                Gap(4.h),
                Text(
                  subtitle,
                  style: context.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          DigifyDivider.horizontal(color: isDark ? AppColors.cardBorderDark : AppColors.cardBorder),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: SizedBox(height: 220.h, width: double.infinity, child: child),
          ),
        ],
      ),
    );
  }
}

class _LineTrendCard extends StatelessWidget {
  const _LineTrendCard();

  @override
  Widget build(BuildContext context) {
    return const _ChartCard(
      title: 'Monthly Compensation Cost Trend',
      subtitle: '6-month cost progression',
      child: CompLineChart(
        values: [1240000, 1260000, 1280000, 1295000, 1300000, 1320000],
        labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
      ),
    );
  }
}

class _StatusDistributionCard extends StatelessWidget {
  const _StatusDistributionCard();

  @override
  Widget build(BuildContext context) {
    return const _ChartCard(
      title: 'Plans by Status',
      subtitle: 'Hover over a segment to view details',
      child: CompPieChart(),
    );
  }
}

class _PlansByTypeCard extends StatelessWidget {
  const _PlansByTypeCard();

  @override
  Widget build(BuildContext context) {
    return const _ChartCard(
      title: 'Plans by Type',
      subtitle: 'Plan type distribution',
      child: CompBarChart(
        values: [8, 4, 3, 1],
        labels: ['Salary Structure', 'Benefits Plan', 'Bonus Plan', 'Incentive Plan'],
      ),
    );
  }
}

class _InsightsAlertsCard extends StatelessWidget {
  const _InsightsAlertsCard();

  @override
  Widget build(BuildContext context) {
    return const _ChartCard(
      title: 'Insights & Alerts',
      subtitle: 'Key notifications and recommendations',
      child: CompInsightsAlerts(),
    );
  }
}
