import 'package:grc/features/compensation/domain/models/employees/employee_adjustment_details.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employees_repository.dart';

class GetEmployeeAdjustmentDetailsUseCase {
  const GetEmployeeAdjustmentDetailsUseCase({required this.repository});

  final EmployeesRepository repository;

  Future<EmployeeAdjustmentDetails> call({required String employeeGuid, required int enterpriseId}) {
    return repository.getEmployeeAdjustmentDetails(employeeGuid: employeeGuid, enterpriseId: enterpriseId);
  }
}
