import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'compensation_plan_detail_overview_charts.dart';
import 'compensation_plan_detail_overview_data.dart';
import 'compensation_plan_detail_overview_shell_card.dart';

class CompensationPlanDetailOverviewDistributionCard extends StatelessWidget {
  final List<GradeDistributionPoint> data;

  const CompensationPlanDetailOverviewDistributionCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return CompensationPlanDetailOverviewShellCard(
      title: 'Employee Distribution by Grade',
      subtitle: 'Headcount and average salary per grade level',
      child: SizedBox(
        height: 250.h,
        child: CompensationPlanDetailGradeDistributionChart(data: data),
      ),
    );
  }
}
