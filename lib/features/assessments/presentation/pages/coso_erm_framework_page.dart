import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/localization/l10n/app_localizations.dart';
import 'package:grc_web/core/router/app_routes.dart';
import 'package:grc_web/core/router/nav_ext.dart';
import 'package:grc_web/core/theme/app_colors.dart';

const _kAssetsDir = 'assets/figma/assessments/svg';

// ─── Colors not in AppColors ─────────────────────────────────────────────────
const _kPrimary = Color(0xFF155DFC);
const _kGreen = Color(0xFF00A63E);
const _kAmber = Color(0xFFD08700);
const _kPurple = Color(0xFF9810FA);
const _kBarPurple = Color(0xFFA78BFA);
const _kAxisText = Color(0xFF6B7280);
const _kGrid = Color(0xFFE5E7EB);
const _kSubLabel = Color(0xFF6A7282);
const _kPillText = Color(0xFF364153);
const _kExportText = Color(0xFF0A0A0A);
const _kBorderInput = Color(0xFFD1D5DC);

// stat icon badges
const _kBgPurple = Color(0xFFF3E8FF);
const _kBgGreen = Color(0xFFDCFCE7);

// recommendation — amber
const _kRecAmberBg = Color(0xFFFEFCE8);
const _kRecAmberBorder = Color(0xFFFFF085);
const _kRecAmberBadgeBg = Color(0xFFFEF9C2);
const _kRecAmberBadgeFg = Color(0xFFA65F00);
const _kRecAmberTitle = Color(0xFF733E0A);
const _kRecAmberBody = Color(0xFFA65F00);
const _kRecAmberMeta = Color(0xFFD08700);

// recommendation — blue
const _kRecBlueBg = Color(0xFFEFF6FF);
const _kRecBlueBorder = Color(0xFFBEDBFF);
const _kRecBlueBadgeBg = Color(0xFFDBEAFE);
const _kRecBlueBadgeFg = Color(0xFF1447E6);
const _kRecBlueTitle = Color(0xFF1C398E);
const _kRecBlueBody = Color(0xFF1447E6);
const _kRecBlueMeta = Color(0xFF155DFC);

class CosoErmFrameworkPage extends StatelessWidget {
  const CosoErmFrameworkPage({super.key});

  static const _components = <_ComponentData>[
    _ComponentData(
      title: 'Governance & Culture',
      shortLabel: 'Governance',
      description:
          'Board oversight, operating structures, and organizational culture',
      strong: 2,
      adequate: 2,
      developing: 0,
      maturity: 4.2,
      maturityLabel: '4.2',
    ),
    _ComponentData(
      title: 'Strategy & Objective-Setting',
      shortLabel: 'Strategy',
      description: 'Strategic planning and risk appetite alignment',
      strong: 2,
      adequate: 2,
      developing: 0,
      maturity: 4.0,
      maturityLabel: '4',
    ),
    _ComponentData(
      title: 'Performance',
      shortLabel: 'Performance',
      description: 'Risk identification, assessment, and prioritization',
      strong: 4,
      adequate: 0,
      developing: 0,
      maturity: 4.3,
      maturityLabel: '4.3',
    ),
    _ComponentData(
      title: 'Review & Revision',
      shortLabel: 'Review',
      description: 'Monitoring and revising risk management practices',
      strong: 0,
      adequate: 2,
      developing: 2,
      maturity: 3.8,
      maturityLabel: '3.8',
    ),
    _ComponentData(
      title: 'Information, Communication & Reporting',
      shortLabel: 'Information, Communication',
      description: 'Risk information flow and reporting',
      strong: 2,
      adequate: 2,
      developing: 0,
      maturity: 4.1,
      maturityLabel: '4.1',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1512.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TitleBar(l10n: l10n),
            SizedBox(height: 24.h),
            const _StatsRow(),
            SizedBox(height: 24.h),
            const _ChartsRow(components: _components),
            SizedBox(height: 24.h),
            for (final c in _components) ...[
              _ComponentCard(data: c),
              SizedBox(height: 16.h),
            ],
            const _RecommendationsCard(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Title bar
// ---------------------------------------------------------------------------

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.l10n});

  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
            onTap: () => context.deferGo(AppRoutes.assessments),
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                border: Border.all(color: _kBorderInput),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  '$_kAssetsDir/back_arrow.svg',
                  width: 20.r,
                  height: 20.r,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'COSO ERM Framework',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w600,
                  height: 32 / 24,
                  letterSpacing: 0.072,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Enterprise Risk Management - Integrated Framework',
                style: TextStyle(
                  color: AppColors.textBody,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 16.w),
        Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.r),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(10.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 17.w, vertical: 9.h),
              decoration: BoxDecoration(
                border: Border.all(color: _kBorderInput),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    '$_kAssetsDir/export.svg',
                    width: 16.r,
                    height: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Export Assessment',
                    style: TextStyle(
                      color: _kExportText,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      height: 24 / 16,
                      letterSpacing: -0.32,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Stats row
// ---------------------------------------------------------------------------

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(
            child: _StatCard(
              icon: 'coso_score.svg',
              iconBg: _kBgPurple,
              value: '4.1',
              label: 'Avg Maturity Score',
              sublabel: 'Out of 5.0',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              icon: 'coso_components.svg',
              iconBg: _kBgGreen,
              value: '5',
              label: 'Components',
              sublabel: 'All assessed',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '10',
              valueColor: _kGreen,
              label: 'Strong Controls',
              sublabel: 'Out of 20 total',
            ),
          ),
          SizedBox(width: 16.w),
          const Expanded(
            child: _StatCard(
              value: '82%',
              valueColor: _kPrimary,
              label: 'Maturity Level',
              sublabel: 'Optimized at 100%',
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.sublabel,
    this.icon,
    this.iconBg,
    this.valueColor = AppColors.textPrimary,
  });

  final String value;
  final String label;
  final String sublabel;
  final String? icon;
  final Color? iconBg;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  '$_kAssetsDir/$icon',
                  width: 20.r,
                  height: 20.r,
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              height: 32 / 24,
              letterSpacing: 0.072,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textBody,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              height: 20 / 14,
              letterSpacing: -0.154,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            sublabel,
            style: TextStyle(
              color: _kSubLabel,
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Charts row
// ---------------------------------------------------------------------------

class _ChartsRow extends StatelessWidget {
  const _ChartsRow({required this.components});

  final List<_ComponentData> components;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _ChartCard(
              title: 'Maturity by Component',
              child: _MaturityBarChart(components: components),
            ),
          ),
          SizedBox(width: 24.w),
          Expanded(
            child: _ChartCard(
              title: 'ERM Maturity Assessment',
              child: _MaturityRadarChart(components: components),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(height: 280.h, child: child),
        ],
      ),
    );
  }
}

class _MaturityBarChart extends StatelessWidget {
  const _MaturityBarChart({required this.components});

  final List<_ComponentData> components;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              maxY: 5,
              minY: 0,
              alignment: BarChartAlignment.spaceAround,
              barTouchData: BarTouchData(enabled: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) =>
                    const FlLine(color: _kGrid, strokeWidth: 1),
              ),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    reservedSize: 28.w,
                    getTitlesWidget: (value, meta) {
                      if (value != 0 && value != 2 && value != 5) {
                        return const SizedBox.shrink();
                      }
                      return Text(
                        '${value.toInt()}',
                        style: TextStyle(color: _kAxisText, fontSize: 14.sp),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 56.h,
                    getTitlesWidget: (value, meta) {
                      final i = value.toInt();
                      if (i < 0 || i >= components.length) {
                        return const SizedBox.shrink();
                      }
                      return SideTitleWidget(
                        meta: meta,
                        space: 8.h,
                        child: Transform.rotate(
                          angle: -0.26,
                          alignment: Alignment.topRight,
                          child: SizedBox(
                            width: 120.w,
                            child: Text(
                              components[i].shortLabel,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                              overflow: TextOverflow.visible,
                              softWrap: false,
                              style:
                                  TextStyle(color: _kAxisText, fontSize: 12.sp),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: [
                for (var i = 0; i < components.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: components[i].maturity,
                        color: _kBarPurple,
                        width: 44.w,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 12.r,
              height: 12.r,
              decoration: BoxDecoration(
                color: _kBarPurple,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              'Maturity Score',
              style: TextStyle(
                color: _kAxisText,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MaturityRadarChart extends StatelessWidget {
  const _MaturityRadarChart({required this.components});

  final List<_ComponentData> components;

  @override
  Widget build(BuildContext context) {
    return RadarChart(
      RadarChartData(
        radarShape: RadarShape.polygon,
        dataSets: [
          RadarDataSet(
            dataEntries: [
              for (final c in components) RadarEntry(value: c.maturity),
            ],
            fillColor: _kPurple.withValues(alpha: 0.3),
            borderColor: _kPurple,
            borderWidth: 2,
            entryRadius: 0,
          ),
        ],
        radarBackgroundColor: Colors.transparent,
        radarBorderData: const BorderSide(color: _kGrid, width: 1),
        gridBorderData: const BorderSide(color: _kGrid, width: 1),
        tickBorderData: const BorderSide(color: _kGrid, width: 1),
        tickCount: 4,
        ticksTextStyle: TextStyle(color: _kAxisText, fontSize: 11.sp),
        titlePositionPercentageOffset: 0.12,
        titleTextStyle: TextStyle(color: _kAxisText, fontSize: 12.sp),
        getTitle: (index, angle) =>
            RadarChartTitle(text: components[index].shortLabel),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Component card
// ---------------------------------------------------------------------------

class _ComponentCard extends StatelessWidget {
  const _ComponentCard({required this.data});

  final _ComponentData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    height: 28 / 18,
                    letterSpacing: -0.45,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  data.description,
                  style: TextStyle(
                    color: AppColors.textBody,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 24.w,
                  runSpacing: 8.h,
                  children: [
                    _StatusPill(color: _kGreen, label: '${data.strong} Strong'),
                    _StatusPill(
                        color: _kPrimary, label: '${data.adequate} Adequate'),
                    _StatusPill(
                        color: _kAmber, label: '${data.developing} Developing'),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                data.maturityLabel,
                style: TextStyle(
                  color: _kPurple,
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w600,
                  height: 36 / 30,
                  letterSpacing: 0.42,
                ),
              ),
              Text(
                'Maturity',
                style: TextStyle(
                  color: _kSubLabel,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  height: 16 / 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: _kPillText,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 20 / 14,
            letterSpacing: -0.154,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Improvement recommendations
// ---------------------------------------------------------------------------

class _RecommendationsCard extends StatelessWidget {
  const _RecommendationsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Improvement Recommendations',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              height: 28 / 18,
              letterSpacing: -0.45,
            ),
          ),
          SizedBox(height: 16.h),
          const _RecommendationItem(
            number: '1',
            title: 'Enhance Review & Revision Process',
            description:
                'Implement quarterly risk portfolio reviews and establish continuous improvement metrics',
            meta: 'Priority: Medium • Impact: High',
            bg: _kRecAmberBg,
            border: _kRecAmberBorder,
            badgeBg: _kRecAmberBadgeBg,
            badgeFg: _kRecAmberBadgeFg,
            titleColor: _kRecAmberTitle,
            bodyColor: _kRecAmberBody,
            metaColor: _kRecAmberMeta,
          ),
          SizedBox(height: 12.h),
          const _RecommendationItem(
            number: '2',
            title: 'Strengthen External Communication',
            description:
                'Develop stakeholder communication framework for risk disclosures',
            meta: 'Priority: Low • Impact: Medium',
            bg: _kRecBlueBg,
            border: _kRecBlueBorder,
            badgeBg: _kRecBlueBadgeBg,
            badgeFg: _kRecBlueBadgeFg,
            titleColor: _kRecBlueTitle,
            bodyColor: _kRecBlueBody,
            metaColor: _kRecBlueMeta,
          ),
        ],
      ),
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  const _RecommendationItem({
    required this.number,
    required this.title,
    required this.description,
    required this.meta,
    required this.bg,
    required this.border,
    required this.badgeBg,
    required this.badgeFg,
    required this.titleColor,
    required this.bodyColor,
    required this.metaColor,
  });

  final String number;
  final String title;
  final String description;
  final String meta;
  final Color bg;
  final Color border;
  final Color badgeBg;
  final Color badgeFg;
  final Color titleColor;
  final Color bodyColor;
  final Color metaColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17.w),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(color: badgeBg, shape: BoxShape.circle),
            child: Center(
              child: Text(
                number,
                style: TextStyle(
                  color: badgeFg,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  height: 20 / 14,
                  letterSpacing: -0.154,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    height: 24 / 16,
                    letterSpacing: -0.32,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: TextStyle(
                    color: bodyColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 20 / 14,
                    letterSpacing: -0.154,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  meta,
                  style: TextStyle(
                    color: metaColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    height: 16 / 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _ComponentData {
  const _ComponentData({
    required this.title,
    required this.shortLabel,
    required this.description,
    required this.strong,
    required this.adequate,
    required this.developing,
    required this.maturity,
    required this.maturityLabel,
  });

  final String title;
  final String shortLabel;
  final String description;
  final int strong;
  final int adequate;
  final int developing;
  final double maturity;
  final String maturityLabel;
}
