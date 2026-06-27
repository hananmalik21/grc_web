import '../models/adjustments/adjustments_page.dart';
import '../models/adjustments/employee_component_history.dart';

abstract class AdjustmentsRepository {
  Future<AdjustmentsPage> getAdjustments({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  });

  Future<List<EmployeeComponentHistory>> getEmployeeLatestComponentHistory({
    required int enterpriseId,
    required int employeeId,
  });
}
