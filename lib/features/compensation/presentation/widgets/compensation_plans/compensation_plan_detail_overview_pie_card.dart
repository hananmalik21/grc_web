import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'compensation_plan_detail_overview_charts.dart';
import 'compensation_plan_detail_overview_data.dart';
import 'compensation_plan_detail_overview_shell_card.dart';

class CompensationPlanDetailOverviewPieCard extends StatelessWidget {
  final List<CostSlice> sections;

  const CompensationPlanDetailOverviewPieCard({super.key, required this.sections});

  @override
  Widget build(BuildContext context) {
    return CompensationPlanDetailOverviewShellCard(
      title: 'Cost Breakdown',
      subtitle: 'Monthly compensation cost distribution',
      child: SizedBox(
        height: 220.h,
        child: CompensationPlanDetailPieChart(sections: sections),
      ),
    );
  }
}
