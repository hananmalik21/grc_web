import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/tabs/available_components_container_widget.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/tabs/linked_plans_container_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class CompensationPlanDetailComponentsTab extends StatelessWidget {
  final CompensationPlan plan;

  const CompensationPlanDetailComponentsTab({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final linkedComponents = plan.components ?? const <PlanComponent>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinkedPlansContainerWidget(linkedComponents: linkedComponents),
        Gap(24.h),
        const AvailableComponentsContainerWidget(),
      ],
    );
  }
}
