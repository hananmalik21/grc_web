import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/create_bulk_adjustment_request.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/employee_eligible_plans.dart';

abstract class BulkAdjustmentsRepository {
  Future<BulkEmployeeComponentsPage> getBulkEmployeeComponents({
    required int enterpriseId,
    required List<String> employeeGuids,
    required int page,
    required int pageSize,
  });

  Future<List<EmployeeEligiblePlans>> getEligiblePlans({required List<String> employeeGuids});

  Future<void> createBulkAdjustment({required CreateBulkAdjustmentRequest request});
}
