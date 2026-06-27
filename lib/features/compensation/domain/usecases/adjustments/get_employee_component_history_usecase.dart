import '../../models/adjustments/employee_component_history.dart';
import '../../repositories/adjustments_repository.dart';

class GetEmployeeComponentHistoryUseCase {
  final AdjustmentsRepository repository;

  const GetEmployeeComponentHistoryUseCase({required this.repository});

  Future<List<EmployeeComponentHistory>> call({
    required int enterpriseId,
    required int employeeId,
  }) {
    return repository.getEmployeeLatestComponentHistory(
      enterpriseId: enterpriseId,
      employeeId: employeeId,
    );
  }
}
