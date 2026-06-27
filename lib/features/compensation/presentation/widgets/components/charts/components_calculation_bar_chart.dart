import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:grc/features/compensation/data/dto/lookups/comp_lookup_graph_count_dto.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComponentsCalculationBarChart extends StatelessWidget {
  final List<CompLookupGraphCountItemDto> items;

  const ComponentsCalculationBarChart({super.key, required this.items});

  // Color mapping for different calculation method codes
  Color _getColorForMethod(String valueCode) {
    return switch (valueCode) {
      'FIXED_AMOUNT' => AppColors.info,
      'PERCENTAGE' => AppColors.success,
      'FORMULA' => AppColors.warning,
      _ => AppColors.primary,
    };
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final maxY = items.isEmpty ? 10.0 : items.map((e) => e.count.toDouble()).reduce((a, b) => a > b ? a : b);
    final gridColor = isDark ? AppColors.cardBorderDark : AppColors.borderGrey;
    final labelColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;
    final axisColor = isDark ? AppColors.textSecondaryDark : AppColors.textTertiary;

    return BarChart(
      BarChartData(
        maxY: maxY,
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        groupsSpace: 6.w,
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
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(color: axisColor, fontSize: 12.sp, fontWeight: FontWeight.w400),
              ),
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
                if (index < 0 || index >= items.length) return const SizedBox.shrink();
                return Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: SizedBox(
                    width: 120.w,
                    child: Text(
                      items[index].valueName,
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
                '${rod.toY.toStringAsFixed(0)} components',
                TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.w600, fontSize: 11.sp),
              );
            },
          ),
        ),
        barGroups: [
          for (var i = 0; i < items.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: items[i].count.toDouble(),
                  color: _getColorForMethod(items[i].valueCode),
                  width: 48.w,
                  borderRadius: BorderRadius.zero,
                ),
              ],
            ),
        ],
      ),
    );
  }
}
