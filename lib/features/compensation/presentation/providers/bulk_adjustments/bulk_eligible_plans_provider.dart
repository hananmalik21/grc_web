import 'package:grc/features/compensation/domain/models/bulk_adjustments/employee_eligible_plans.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_adjustments_api_providers.dart';
import 'package:grc/features/compensation/presentation/providers/bulk_adjustments/bulk_employee_components_provider.dart';
import 'package:grc/features/compensation/presentation/utils/bulk_eligible_plans_intersection.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bulkEligiblePlansByEmployeeProvider = FutureProvider.autoDispose<List<EmployeeEligiblePlans>>((ref) async {
  final query = ref.watch(bulkEmployeeComponentsQueryProvider);
  if (query == null || query.employeeGuids.isEmpty) return [];

  final useCase = ref.watch(getBulkEligiblePlansUseCaseProvider);
  return useCase(employeeGuids: query.employeeGuids);
});

final bulkSharedEligiblePlansProvider = Provider.autoDispose<List<CompensationPlan>>((ref) {
  final asyncValue = ref.watch(bulkEligiblePlansByEmployeeProvider);
  return asyncValue.when(data: intersectEligiblePlansAcrossEmployees, loading: () => [], error: (_, _) => []);
});
