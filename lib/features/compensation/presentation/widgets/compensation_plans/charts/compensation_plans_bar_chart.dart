import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompBarChart extends StatelessWidget {
  final List<double> values;
  final List<String> labels;

  const CompBarChart({super.key, required this.values, required this.labels});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final maxY = values.reduce((a, b) => a > b ? a : b);
    final gridColor = isDark ? AppColors.cardBorderDark : const Color(0xFFD0D5DD);
    final labelColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF667085);
    final axisColor = isDark ? AppColors.textSecondaryDark : const Color(0xFF666666);

    return BarChart(
      BarChartData(
        maxY: maxY.toDouble(),
        minY: 0,
        alignment: BarChartAlignment.spaceBetween,
        groupsSpace: 14.w,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 2,
          verticalInterval: 1,
          getDrawingHorizontalLine: (_) => FlLine(color: gridColor, strokeWidth: 1, dashArray: const [4, 4]),
          getDrawingVerticalLine: (_) => FlLine(color: gridColor, strokeWidth: 1, dashArray: const [4, 4]),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border(
            left: BorderSide(color: axisColor, width: 1),
            bottom: BorderSide(color: axisColor, width: 1),
            top: BorderSide.none,
            right: BorderSide.none,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24.w,
              interval: 2,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: TextStyle(color: axisColor, fontSize: 12.sp, fontWeight: FontWeight.w400),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30.h,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= labels.length) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: SizedBox(
                    width: 120.w,
                    child: Text(
                      labels[index],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: labelColor, fontSize: 12.sp, fontWeight: FontWeight.w400),
                    ),
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
              return BarTooltipItem(
                '${rod.toY.toStringAsFixed(0)} plans',
                TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 11.sp),
              );
            },
          ),
        ),
        barGroups: [
          for (var i = 0; i < values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(toY: values[i], color: AppColors.primary, width: 48.w, borderRadius: BorderRadius.zero),
              ],
            ),
        ],
      ),
    );
  }
}
