import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';
import 'package:grc/features/compensation/domain/repositories/bulk_adjustments/bulk_adjustments_repository.dart';

class GetBulkEmployeeComponentsUseCase {
  const GetBulkEmployeeComponentsUseCase({required this.repository});

  final BulkAdjustmentsRepository repository;

  Future<BulkEmployeeComponentsPage> call({
    required int enterpriseId,
    required List<String> employeeGuids,
    required int page,
    required int pageSize,
  }) {
    return repository.getBulkEmployeeComponents(
      enterpriseId: enterpriseId,
      employeeGuids: employeeGuids,
      page: page,
      pageSize: pageSize,
    );
  }
}
