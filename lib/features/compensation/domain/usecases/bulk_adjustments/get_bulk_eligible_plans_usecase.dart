import 'package:grc/features/compensation/domain/models/bulk_adjustments/employee_eligible_plans.dart';
import 'package:grc/features/compensation/domain/repositories/bulk_adjustments/bulk_adjustments_repository.dart';

class GetBulkEligiblePlansUseCase {
  GetBulkEligiblePlansUseCase({required this.repository});

  final BulkAdjustmentsRepository repository;

  Future<List<EmployeeEligiblePlans>> call({required List<String> employeeGuids}) {
    return repository.getEligiblePlans(employeeGuids: employeeGuids);
  }
}
