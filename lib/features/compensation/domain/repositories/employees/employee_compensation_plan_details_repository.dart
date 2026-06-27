import 'package:grc/features/compensation/domain/models/employees/employee_compensation_plan_details.dart';

abstract class EmployeeCompensationPlanDetailsRepository {
  Future<EmployeeCompensationPlanDetails> getEmployeeCompensationPlanDetails({
    required int enterpriseId,
    required String employeeGuid,
    required String planGuid,
  });
}
