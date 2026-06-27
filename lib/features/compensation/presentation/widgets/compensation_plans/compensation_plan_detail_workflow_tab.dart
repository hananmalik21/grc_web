import 'package:flutter/material.dart';

import 'compensation_plan_detail_tabs/workflow/compensation_plan_detail_workflow_data.dart';
import 'compensation_plan_detail_tabs/workflow/compensation_plan_detail_workflow_panel.dart';

class CompensationPlanDetailWorkflowTab extends StatelessWidget {
  const CompensationPlanDetailWorkflowTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const CompensationPlanDetailWorkflowPanel(events: CompensationPlanDetailWorkflowData.events);
  }
}
