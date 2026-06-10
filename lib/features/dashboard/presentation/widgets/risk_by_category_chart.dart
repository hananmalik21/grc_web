import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:grc_web/core/theme/app_colors.dart';

class RiskByCategoryChart extends StatelessWidget {
  const RiskByCategoryChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Fill the chart card area — Figma pie is ~230px in a 300px-tall panel.
        final size = math.min(constraints.maxWidth, constraints.maxHeight);
        final radius = (size / 2) - 1;

        final sections = <PieChartSectionData>[
          PieChartSectionData(value: 25, color: AppColors.pieBlue, radius: radius, title: ''),
          PieChartSectionData(value: 15, color: AppColors.pieGreen, radius: radius, title: ''),
          PieChartSectionData(value: 17, color: AppColors.pieOrange, radius: radius, title: ''),
          PieChartSectionData(value: 20, color: AppColors.piePink, radius: radius, title: ''),
          PieChartSectionData(value: 23, color: AppColors.piePurple, radius: radius, title: ''),
        ];

        return Center(
          child: SizedBox(
            width: size,
            height: size,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 0,
                sectionsSpace: 1,
                startDegreeOffset: -90,
                borderData: FlBorderData(show: false),
              ),
            ),
          ),
        );
      },
    );
  }
}
