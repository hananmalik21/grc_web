import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/chart_legend.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/overview_shell_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class MonthlyTrendPoint {
  final String month;
  final double actual;
  final double projected;

  const MonthlyTrendPoint({required this.month, required this.actual, required this.projected});
}

class CompensationPlanDetailOverviewTrendCard extends StatelessWidget {
  final List<MonthlyTrendPoint> series;

  const CompensationPlanDetailOverviewTrendCard({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return OverviewShellCard(
      title: 'Monthly Cost Trend',
      subtitle: 'Actual vs projected compensation costs',
      child: SizedBox(
        height: 250.h,
        child: _MonthlyTrendChart(series: series),
      ),
    );
  }
}

class _MonthlyTrendChart extends StatelessWidget {
  final List<MonthlyTrendPoint> series;

  const _MonthlyTrendChart({required this.series});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final gridColor = isDark ? AppColors.borderGreyDark : AppColors.borderGrey;
    final axisTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final actualZeroStartIndex = _findFlatZeroStartIndex((point) => point.actual);
    final projectedZeroStartIndex = _findFlatZeroStartIndex((point) => point.projected);

    return Column(
      children: [
        Expanded(
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: (series.length - 1).toDouble(),
              minY: 0,
              maxY: 600000,
              gridData: FlGridData(
                show: true,
                horizontalInterval: 150000,
                verticalInterval: 1,
                getDrawingHorizontalLine: (_) => FlLine(color: gridColor, strokeWidth: 1, dashArray: const [4, 4]),
                getDrawingVerticalLine: (_) => FlLine(color: gridColor, strokeWidth: 1, dashArray: const [4, 4]),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: axisTextColor),
                  bottom: BorderSide(color: axisTextColor),
                  right: BorderSide.none,
                  top: BorderSide.none,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 56.w,
                    interval: 150000,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        value.toInt().toString(),
                        style: TextStyle(color: axisTextColor, fontSize: 12.sp),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 28.h,
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      if (index < 0 || index >= series.length) return const SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          series[index].month,
                          style: TextStyle(color: axisTextColor, fontSize: 12.sp),
                        ),
                      );
                    },
                  ),
                ),
              ),
              lineTouchData: LineTouchData(
                enabled: true,
                touchTooltipData: LineTouchTooltipData(
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((touchedSpot) {
                      final point = series[touchedSpot.x.toInt()];
                      final isActualSeries = touchedSpot.barIndex < 2;
                      final label = isActualSeries ? 'Actual' : 'Projected';
                      final value = isActualSeries ? point.actual : point.projected;

                      return LineTooltipItem(
                        '$label\n${point.month}: ${value.toStringAsFixed(0)} KWD',
                        TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600, fontSize: 11.sp),
                      );
                    }).toList();
                  },
                ),
              ),
              lineBarsData: [
                ..._buildSeriesBars(
                  selector: (point) => point.actual,
                  color: AppColors.primary,
                  zeroStartIndex: actualZeroStartIndex,
                ),
                ..._buildSeriesBars(
                  selector: (point) => point.projected,
                  color: AppColors.success,
                  zeroStartIndex: projectedZeroStartIndex,
                ),
              ],
            ),
          ),
        ),
        Gap(14.h),
        const ChartLegend(
          items: [
            LegendItemData(label: 'Actual', color: AppColors.primary, isLine: true),
            LegendItemData(label: 'Projected', color: AppColors.success, isLine: true),
          ],
        ),
      ],
    );
  }

  int _findFlatZeroStartIndex(double Function(MonthlyTrendPoint point) selector) {
    for (var index = 0; index < series.length; index++) {
      if (selector(series[index]) != 0) continue;

      final allRemainingZero = series.skip(index).every((point) => selector(point) == 0);
      if (allRemainingZero) {
        return index;
      }
    }

    return -1;
  }

  List<LineChartBarData> _buildSeriesBars({
    required double Function(MonthlyTrendPoint point) selector,
    required Color color,
    required int zeroStartIndex,
  }) {
    final allSpots = [for (var i = 0; i < series.length; i++) FlSpot(i.toDouble(), selector(series[i]))];

    if (zeroStartIndex <= 0) {
      return [_buildSeriesLine(spots: allSpots, color: color, isCurved: true, showDots: true)];
    }

    final leadingSpots = allSpots.take(zeroStartIndex + 1).toList();
    final flatZeroSpots = allSpots.skip(zeroStartIndex).toList();

    return [
      _buildSeriesLine(spots: leadingSpots, color: color, isCurved: true, showDots: true),
      _buildSeriesLine(spots: flatZeroSpots, color: color, isCurved: false, showDots: true),
    ];
  }

  LineChartBarData _buildSeriesLine({
    required List<FlSpot> spots,
    required Color color,
    required bool isCurved,
    required bool showDots,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: isCurved,
      curveSmoothness: isCurved ? 0.3 : 0,
      preventCurveOverShooting: true,
      color: color,
      barWidth: 1.8,
      isStrokeCapRound: true,
      dashArray: color == AppColors.success ? const [5, 4] : null,
      dotData: FlDotData(
        show: showDots,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(radius: 3.2, color: AppColors.cardBackground, strokeWidth: 1.5, strokeColor: color);
        },
      ),
    );
  }
}
