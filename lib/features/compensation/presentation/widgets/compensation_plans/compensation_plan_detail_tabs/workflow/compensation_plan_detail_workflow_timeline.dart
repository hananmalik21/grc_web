import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'compensation_plan_detail_workflow_data.dart';
import 'compensation_plan_detail_workflow_timeline_item.dart';

class CompensationPlanDetailWorkflowTimeline extends StatelessWidget {
  final List<WorkflowEvent> events;

  const CompensationPlanDetailWorkflowTimeline({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          for (var i = 0; i < events.length; i++)
            CompensationPlanDetailWorkflowTimelineItem(event: events[i], showConnector: i != events.length - 1),
        ],
      ),
    );
  }
}
