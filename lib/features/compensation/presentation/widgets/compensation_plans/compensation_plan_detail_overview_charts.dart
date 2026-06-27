import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import 'compensation_plan_detail_overview_data.dart';

class CompensationPlanDetailPieChart extends StatelessWidget {
  final List<CostSlice> sections;

  const CompensationPlanDetailPieChart({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          child: SizedBox(
            width: 160.w,
            height: 160.w,
            child: PieChart(
              PieChartData(
                sectionsSpace: 1,
                centerSpaceRadius: 0,
                startDegreeOffset: 0,
                borderData: FlBorderData(show: false),
                sections: sections
                    .map(
                      (section) =>
                          PieChartSectionData(color: section.color, value: section.percentage, title: '', radius: 69.w),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
        for (final label in _buildPieLabels(context, sections)) label,
      ],
    );
  }

  List<Widget> _buildPieLabels(BuildContext context, List<CostSlice> items) {
    final labelStyle = context.textTheme.bodyMedium?.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w400);

    return [
      Positioned(
        top: 0,
        left: 88.w,
        child: Text(
          '${items[0].label} (${items[0].percentage.toStringAsFixed(1)}%)',
          style: labelStyle?.copyWith(color: items[0].color),
        ),
      ),
      Positioned(
        left: 80.w,
        bottom: 16.h,
        child: Text(
          '${items[1].label} (${items[1].percentage.toStringAsFixed(1)}%)',
          style: labelStyle?.copyWith(color: items[1].color),
        ),
      ),
      Positioned(
        right: 44.w,
        bottom: 34.h,
        child: Text(
          '${items[2].label} (${items[2].percentage.toStringAsFixed(1)}%)',
          style: labelStyle?.copyWith(color: items[2].color),
        ),
      ),
      Positioned(
        right: 18.w,
        top: 94.h,
        child: Text(
          '${items[3].label} (${items[3].percentage.toStringAsFixed(1)}%)',
          style: labelStyle?.copyWith(color: items[3].color),
        ),
      ),
    ];
  }
}

class CompensationPlanDetailGradeDistributionChart extends StatelessWidget {
  final List<GradeDistributionPoint> data;

  const CompensationPlanDetailGradeDistributionChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final gridColor = isDark ? AppColors.borderGreyDark : const Color(0xFFD0D5DD);
    final axisTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF666666);
    final xLabelColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF667085);

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              minY: 0,
              maxY: 12,
              alignment: BarChartAlignment.spaceAround,
              groupsSpace: 20.w,
              gridData: FlGridData(
                show: true,
                horizontalInterval: 3,
                verticalInterval: 1,
                getDrawingHorizontalLine: (_) => FlLine(color: gridColor, strokeWidth: 1, dashArray: const [4, 4]),
                getDrawingVerticalLine: (_) => FlLine(color: gridColor, strokeWidth: 1, dashArray: const [4, 4]),
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  left: BorderSide(color: axisTextColor),
                  bottom: BorderSide(color: axisTextColor),
                  right: BorderSide(color: axisTextColor),
                  top: BorderSide.none,
                ),
              ),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 50.w,
                    interval: 3,
                    getTitlesWidget: (value, meta) {
                      final mappedSalary = ((value / 12) * 22000).round();
                      return Text(
                        mappedSalary.toString(),
                        style: TextStyle(color: axisTextColor, fontSize: 12.sp),
                      );
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 24.w,
                    interval: 3,
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
                      if (index < 0 || index >= data.length) return const SizedBox.shrink();
                      return Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          data[index].grade,
                          style: TextStyle(color: xLabelColor, fontSize: 12.sp),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barTouchData: BarTouchData(enabled: false),
              extraLinesData: ExtraLinesData(
                extraLinesOnTop: false,
                verticalLines: [
                  for (var i = 0; i < data.length; i++) VerticalLine(x: i.toDouble(), color: Colors.transparent),
                ],
              ),
              barGroups: [
                for (var i = 0; i < data.length; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 0,
                    groupVertically: false,
                    barRods: [
                      BarChartRodData(
                        toY: data[i].employeeCount,
                        color: AppColors.primary,
                        width: 16.w,
                        borderRadius: BorderRadius.zero,
                      ),
                      BarChartRodData(
                        toY: (data[i].averageSalary / 22000) * 12,
                        color: const Color(0xFF10B981),
                        width: 16.w,
                        borderRadius: BorderRadius.zero,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        Gap(14.h),
        const _ChartLegend(
          items: [
            _LegendItemData(label: 'Employee Count', color: AppColors.primary),
            _LegendItemData(label: 'Avg Salary (KWD)', color: Color(0xFF10B981)),
          ],
        ),
      ],
    );
  }
}

class CompensationPlanDetailMonthlyTrendChart extends StatelessWidget {
  final List<MonthlyTrendPoint> series;

  const CompensationPlanDetailMonthlyTrendChart({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final gridColor = isDark ? AppColors.borderGreyDark : const Color(0xFFD0D5DD);
    final axisTextColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF666666);

    List<FlSpot> buildSpots(double Function(MonthlyTrendPoint point) selector) {
      return [for (var i = 0; i < series.length; i++) FlSpot(i.toDouble(), selector(series[i]))];
    }

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
              lineTouchData: LineTouchData(enabled: false),
              lineBarsData: [
                _buildSeriesLine(buildSpots((point) => point.actual), AppColors.primary),
                _buildSeriesLine(buildSpots((point) => point.projected), const Color(0xFF10B981)),
              ],
            ),
          ),
        ),
        Gap(14.h),
        const _ChartLegend(
          items: [
            _LegendItemData(label: 'Actual', color: AppColors.primary, isLine: true),
            _LegendItemData(label: 'Projected', color: Color(0xFF10B981), isLine: true),
          ],
        ),
      ],
    );
  }

  LineChartBarData _buildSeriesLine(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.3,
      color: color,
      barWidth: 1.8,
      isStrokeCapRound: true,
      dashArray: color == const Color(0xFF10B981) ? const [5, 4] : null,
      dotData: FlDotData(
        show: true,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(radius: 3.2, color: Colors.white, strokeWidth: 1.5, strokeColor: color);
        },
      ),
    );
  }
}

class _LegendItemData {
  final String label;
  final Color color;
  final bool isLine;

  const _LegendItemData({required this.label, required this.color, this.isLine = false});
}

class _ChartLegend extends StatelessWidget {
  final List<_LegendItemData> items;

  const _ChartLegend({required this.items});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12.w,
      runSpacing: 8.h,
      children: items
          .map(
            (item) => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                item.isLine
                    ? SizedBox(
                        width: 14.w,
                        child: Divider(color: item.color, thickness: 2, height: 2),
                      )
                    : Container(width: 10.w, height: 10.w, color: item.color),
                Gap(4.w),
                Text(
                  item.label,
                  style: context.textTheme.bodyMedium?.copyWith(fontSize: 16.sp, color: item.color),
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
