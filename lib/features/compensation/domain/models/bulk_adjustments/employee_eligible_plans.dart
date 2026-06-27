import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';

class EmployeeEligiblePlans {
  const EmployeeEligiblePlans({
    required this.employeeId,
    required this.employeeGuid,
    required this.enterpriseId,
    required this.plans,
  });

  final int employeeId;
  final String employeeGuid;
  final int enterpriseId;
  final List<CompensationPlan> plans;
}
