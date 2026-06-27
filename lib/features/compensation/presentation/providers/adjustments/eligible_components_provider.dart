import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';
import 'package:grc/features/compensation/presentation/providers/compensation_plans/compensation_plans_common_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final eligiblePlansProvider = FutureProvider.autoDispose.family<List<CompensationPlan>, String>((
  ref,
  employeeGuid,
) async {
  final useCase = ref.watch(getEligiblePlansForEmployeeUseCaseProvider);
  return useCase(employeeGuid: employeeGuid);
});

final eligiblePlanComponentsProvider = FutureProvider.autoDispose.family<List<PlanComponent>, String>((
  ref,
  employeeGuid,
) async {
  final plans = await ref.watch(eligiblePlansProvider(employeeGuid).future);

  final seen = <int>{};
  final result = <PlanComponent>[];
  for (final plan in plans) {
    for (final comp in plan.components ?? <PlanComponent>[]) {
      if (seen.add(comp.componentId)) {
        result.add(comp);
      }
    }
  }
  return result;
});
