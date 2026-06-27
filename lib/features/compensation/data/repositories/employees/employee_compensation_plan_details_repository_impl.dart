import 'package:grc/features/compensation/data/datasources/employees/employee_compensation_plan_details_remote_data_source.dart';
import 'package:grc/features/compensation/domain/models/employees/employee_compensation_plan_details.dart';
import 'package:grc/features/compensation/domain/repositories/employees/employee_compensation_plan_details_repository.dart';

class EmployeeCompensationPlanDetailsRepositoryImpl implements EmployeeCompensationPlanDetailsRepository {
  const EmployeeCompensationPlanDetailsRepositoryImpl({required this.remoteDataSource});

  final EmployeeCompensationPlanDetailsRemoteDataSource remoteDataSource;

  @override
  Future<EmployeeCompensationPlanDetails> getEmployeeCompensationPlanDetails({
    required int enterpriseId,
    required String employeeGuid,
    required String planGuid,
  }) {
    return remoteDataSource.getEmployeeCompensationPlanDetails(
      enterpriseId: enterpriseId,
      employeeGuid: employeeGuid,
      planGuid: planGuid,
    );
  }
}
