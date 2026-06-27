import 'package:grc/features/compensation/domain/models/bulk_adjustments/employee_eligible_plans.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';

List<CompensationPlan> intersectEligiblePlansAcrossEmployees(List<EmployeeEligiblePlans> entries) {
  if (entries.isEmpty) return [];

  final requiredCount = entries.length;
  final planCounts = <int, int>{};
  for (final entry in entries) {
    for (final plan in entry.plans) {
      planCounts[plan.planId] = (planCounts[plan.planId] ?? 0) + 1;
    }
  }

  final sharedPlanIds = planCounts.entries
      .where((entry) => entry.value == requiredCount)
      .map((entry) => entry.key)
      .toSet();

  return entries.first.plans.where((plan) => sharedPlanIds.contains(plan.planId)).toList();
}

List<PlanComponent> intersectPlanComponentsAcrossEmployees({
  required List<EmployeeEligiblePlans> entries,
  required int planId,
}) {
  if (entries.isEmpty) return [];

  final componentIdsPerEmployee = <Set<int>>[];
  CompensationPlan? referencePlan;

  for (final entry in entries) {
    final plan = entry.plans.where((p) => p.planId == planId).firstOrNull;
    if (plan == null) return [];
    referencePlan ??= plan;
    final ids = plan.components?.map((c) => c.componentId).toSet() ?? {};
    componentIdsPerEmployee.add(ids);
  }

  var sharedIds = componentIdsPerEmployee.first;
  for (var i = 1; i < componentIdsPerEmployee.length; i++) {
    sharedIds = sharedIds.intersection(componentIdsPerEmployee[i]);
  }

  if (sharedIds.isEmpty || referencePlan == null) return [];

  return referencePlan.components?.where((c) => sharedIds.contains(c.componentId)).toList() ?? [];
}

CompensationPlan? findEmployeePlan({required EmployeeEligiblePlans entry, required int planId}) {
  return entry.plans.where((plan) => plan.planId == planId).firstOrNull;
}
