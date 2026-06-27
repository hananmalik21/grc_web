import '../models/employee_details.dart';
import '../repositories/user_management_repository.dart';

class GetEmployeeDetailsUseCase {
  final UserManagementRepository repository;

  GetEmployeeDetailsUseCase(this.repository);

  Future<EmployeeDetails> call({required String employeeGuid, int? enterpriseId}) {
    return repository.getEmployeeDetails(employeeGuid: employeeGuid, enterpriseId: enterpriseId);
  }
}
