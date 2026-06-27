import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/presentation/widgets/compensation_plans/compensation_plan_detail_tabs/cards/compensation_plan_detail_component_display_card.dart';
import 'package:flutter/material.dart';

class LinkedComponentCardWidget extends StatelessWidget {
  final PlanComponent row;

  const LinkedComponentCardWidget({super.key, required this.row});

  @override
  Widget build(BuildContext context) {
    return CompensationPlanDetailComponentDisplayCard(
      name: row.componentName,
      code: row.componentCode,
      type: row.componentType,
      category: row.componentCategory,
      status: row.componentStatus,
      description: row.componentDescription,
    );
  }
}
