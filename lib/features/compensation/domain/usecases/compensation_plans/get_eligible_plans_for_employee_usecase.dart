import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';
import 'package:grc/features/compensation/domain/repositories/compensation_plans/compensation_plans_repository.dart';

class GetEligiblePlansForEmployeeUseCase {
  final CompensationPlansRepository repository;

  GetEligiblePlansForEmployeeUseCase({required this.repository});

  Future<List<CompensationPlan>> call({required String employeeGuid}) async {
    return await repository.getEligiblePlansForEmployee(employeeGuid: employeeGuid);
  }
}
