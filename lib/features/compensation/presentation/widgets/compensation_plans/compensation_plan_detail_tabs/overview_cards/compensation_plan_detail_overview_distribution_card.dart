import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/chart_legend.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/overview_cards/overview_shell_card.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class GradeDistributionPoint {
  final String grade;
  final double employeeCount;
  final double averageSalary;

  const GradeDistributionPoint({required this.grade, required this.employeeCount, required this.averageSalary});
}

class CompensationPlanDetailOverviewDistributionCard extends StatelessWidget {
  final List<GradeDistributionPoint> data;

  const CompensationPlanDetailOverviewDistributionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return OverviewShellCard(
      title: 'Employee Distribution by Grade',
      subtitle: 'Headcount and average salary per grade level',
      child: SizedBox(
        height: 250.h,
        child: _GradeDistributionChart(data: data),
      ),
    );
  }
}

class _GradeDistributionChart extends StatelessWidget {
  final List<GradeDistributionPoint> data;

  const _GradeDistributionChart({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final gridColor = isDark ? AppColors.borderGreyDark : AppColors.borderGrey;
    final axisTextColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final xLabelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

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
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  tooltipPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final point = data[group.x.toInt()];
                    final isEmployeeCountRod = rodIndex == 0;
                    final tooltipLabel = isEmployeeCountRod ? 'Employee Count' : 'Avg Salary';
                    final tooltipValue = isEmployeeCountRod
                        ? point.employeeCount.toStringAsFixed(0)
                        : '${point.averageSalary.toStringAsFixed(0)} KWD';

                    return BarTooltipItem(
                      '$tooltipLabel\n$tooltipValue',
                      TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600, fontSize: 11.sp),
                    );
                  },
                ),
              ),
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
                        color: AppColors.success,
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
        const ChartLegend(
          items: [
            LegendItemData(label: 'Employee Count', color: AppColors.primary),
            LegendItemData(label: 'Avg Salary (KWD)', color: AppColors.success),
          ],
        ),
      ],
    );
  }
}
