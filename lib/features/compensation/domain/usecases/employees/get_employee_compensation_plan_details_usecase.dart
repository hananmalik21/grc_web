import 'package:grc/features/compensation/domain/models/employees/employee_compensation_plan_details.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employee_compensation_plan_details_repository.dart';

class GetEmployeeCompensationPlanDetailsUseCase {
  final EmployeeCompensationPlanDetailsRepository repository;

  const GetEmployeeCompensationPlanDetailsUseCase({required this.repository});

  Future<EmployeeCompensationPlanDetails> call({
    required int enterpriseId,
    required String employeeGuid,
    required String planGuid,
  }) {
    return repository.getEmployeeCompensationPlanDetails(
      enterpriseId: enterpriseId,
      employeeGuid: employeeGuid,
      planGuid: planGuid,
    );
  }
}
