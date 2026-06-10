import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grc_web/core/localization/app_localizations_ext.dart';
import 'package:grc_web/core/services/responsive_service.dart';
import 'package:grc_web/core/theme/app_colors.dart';

class RiskExposureTrendChart extends StatelessWidget {
  const RiskExposureTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final compact = context.screenLayout.isCompact;

    final axisFontSize = compact ? context.responsive(mobile: 10.0, tablet: 12.0, desktop: 16.0).sp : 16.sp;
    final leftReserved = compact ? context.responsive(mobile: 36.0, tablet: 42.0, desktop: 50.0).w : 50.w;
    final leftPadding = compact ? context.responsive(mobile: 36.0, tablet: 42.0, desktop: 50.0).w : 50.w;
    final bottomPadding = compact ? context.responsive(mobile: 36.0, tablet: 40.0, desktop: 44.0).h : 44.h;
    final bottomReserved = compact ? context.responsive(mobile: 20.0, tablet: 22.0, desktop: 24.0).h : 24.h;

    final axisStyle = TextStyle(
      fontSize: axisFontSize,
      height: 1.0,
      color: AppColors.axisLabel,
    );

    final spots = <FlSpot>[
      const FlSpot(0, 18.8),
      const FlSpot(1, 18.0),
      const FlSpot(2, 17.2),
      const FlSpot(3, 16.4),
      const FlSpot(4, 16.4),
    ];

    String yLabel(double value) {
      if (compact) {
        return switch (value.toInt()) {
          0 => r'$0',
          5 => r'$5M',
          10 => r'$10M',
          15 => r'$15M',
          20 => r'$20M',
          _ => '',
        };
      }
      return switch (value.toInt()) {
        0 => r'$0.0M',
        5 => r'$5.0M',
        10 => r'$10.0M',
        15 => r'$15.0M',
        20 => r'$20.0M',
        _ => '',
      };
    }

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: leftPadding, right: 8.w, top: 6.h, bottom: bottomPadding),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 4,
              minY: 0,
              maxY: 20,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: !compact,
                drawHorizontalLine: true,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: AppColors.chartGrid.withValues(alpha: 0.6),
                  strokeWidth: 1,
                  dashArray: compact ? null : [3, 3],
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: AppColors.chartGrid.withValues(alpha: 0.6),
                  strokeWidth: 1,
                  dashArray: [3, 3],
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                  left: BorderSide(color: Color(0xFF9CA3AF), width: 1),
                  bottom: BorderSide(color: Color(0xFF9CA3AF), width: 1),
                  top: BorderSide(color: Colors.transparent),
                  right: BorderSide(color: Colors.transparent),
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: bottomReserved,
                    interval: 1,
                    getTitlesWidget: (value, meta) {
                      final text = switch (value.toInt()) {
                        0 => 'Jan',
                        1 => 'Feb',
                        2 => 'Mar',
                        3 => 'Apr',
                        4 => 'May',
                        _ => '',
                      };
                      return SideTitleWidget(
                        meta: meta,
                        space: 4.h,
                        child: Text(text, style: axisStyle, textAlign: TextAlign.center),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: leftReserved,
                    interval: compact ? 10 : 5,
                    getTitlesWidget: (value, meta) {
                      final label = yLabel(value);
                      if (label.isEmpty) return const SizedBox.shrink();
                      return SideTitleWidget(
                        meta: meta,
                        space: 4.w,
                        child: Text(label, style: axisStyle, textAlign: TextAlign.right),
                      );
                    },
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: false,
                  barWidth: compact ? 1.5 : 2,
                  color: AppColors.chartLine,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 8.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 14.r,
                height: 14.r,
                alignment: Alignment.center,
                child: Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: const BoxDecoration(
                    color: AppColors.chartLegend,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                l10n.riskExposureLabel,
                style: TextStyle(
                  fontSize: compact ? context.responsive(mobile: 12.0, tablet: 14.0, desktop: 16.0).sp : 16.sp,
                  height: 24 / 16,
                  letterSpacing: -0.32,
                  color: AppColors.chartLegend,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
