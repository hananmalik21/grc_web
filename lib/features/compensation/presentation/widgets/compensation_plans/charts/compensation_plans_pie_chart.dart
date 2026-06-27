import 'package:grc/core/constants/app_colors.dart';
import 'package:grc/core/theme/theme_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../compensation_plans_config.dart';

class CompPieChart extends StatefulWidget {
  const CompPieChart({super.key});

  @override
  State<CompPieChart> createState() => _CompPieChartState();
}

class _CompPieChartState extends State<CompPieChart> {
  int touchedIndex = -1;
  Offset? tooltipPosition;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final sections = [
      for (var i = 0; i < CompensationPlansConfig.statusDistributionLegend.length; i++)
        _buildSection(
          item: CompensationPlansConfig.statusDistributionLegend[i],
          isDark: isDark,
          isTouched: i == touchedIndex,
        ),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 3,
          child: AspectRatio(
            aspectRatio: 1,
            child: MouseRegion(
              onExit: (_) => setState(() {
                touchedIndex = -1;
                tooltipPosition = null;
              }),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.backgroundDark : const Color(0xFFF2F3F5),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    padding: EdgeInsets.all(12.w),
                    child: PieChart(
                      PieChartData(
                        sections: sections,
                        sectionsSpace: 0,
                        centerSpaceRadius: 0,
                        startDegreeOffset: 0,
                        borderData: FlBorderData(show: false),
                        pieTouchData: PieTouchData(
                          enabled: true,
                          touchCallback: (event, pieTouchResponse) {
                            final nextIndex = event.isInterestedForInteractions
                                ? pieTouchResponse?.touchedSection?.touchedSectionIndex ?? -1
                                : -1;

                            setState(() {
                              touchedIndex = nextIndex;
                              if (nextIndex >= 0) {
                                tooltipPosition = event.localPosition;
                              } else {
                                tooltipPosition = null;
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  if (touchedIndex >= 0 && tooltipPosition != null)
                    Positioned(
                      left: (tooltipPosition?.dx ?? 0) - 40.w,
                      top: (tooltipPosition?.dy ?? 0) - 50.h,
                      child: _PieTooltip(
                        item: CompensationPlansConfig.statusDistributionLegend[touchedIndex],
                        isDark: isDark,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        Gap(20.w),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: CompensationPlansConfig.statusDistributionLegend
                .map((item) => _LegendItem(label: item.label, color: item.color, value: item.value))
                .toList(),
          ),
        ),
      ],
    );
  }

  PieChartSectionData _buildSection({
    required ({String label, String value, Color color}) item,
    required bool isDark,
    required bool isTouched,
  }) {
    return PieChartSectionData(
      color: item.color,
      value: double.tryParse(item.value) ?? 0,
      title: '',
      radius: isTouched ? 98.w : 92.w,
      borderSide: BorderSide(color: isDark ? AppColors.cardBackgroundDark : Colors.white, width: 1.2),
    );
  }
}

class _PieTooltip extends StatelessWidget {
  final ({String label, String value, Color color}) item;
  final bool isDark;

  const _PieTooltip({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[800],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: item.color, width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
              ),
              Gap(8.w),
              Text(
                item.label,
                style: context.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          Gap(6.h),
          Text(
            'Count: ${item.value}',
            style: context.textTheme.labelSmall?.copyWith(color: Colors.white70, fontSize: 10.sp),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final String value;

  const _LegendItem({required this.label, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          Gap(8.w),
          Expanded(child: Text(label, style: context.textTheme.bodySmall)),
          Text(value, style: context.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
