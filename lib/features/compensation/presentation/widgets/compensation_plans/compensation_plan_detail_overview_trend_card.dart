import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'compensation_plan_detail_overview_charts.dart';
import 'compensation_plan_detail_overview_data.dart';
import 'compensation_plan_detail_overview_shell_card.dart';

class CompensationPlanDetailOverviewTrendCard extends StatelessWidget {
  final List<MonthlyTrendPoint> series;

  const CompensationPlanDetailOverviewTrendCard({super.key, required this.series});

  @override
  Widget build(BuildContext context) {
    return CompensationPlanDetailOverviewShellCard(
      title: 'Monthly Cost Trend',
      subtitle: 'Actual vs projected compensation costs',
      child: SizedBox(
        height: 250.h,
        child: CompensationPlanDetailMonthlyTrendChart(series: series),
      ),
    );
  }
}
