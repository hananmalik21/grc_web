import 'package:grc/features/compensation/data/datasources/bulk_adjustments/bulk_adjustments_remote_data_source.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/bulk_employee_components_page.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/create_bulk_adjustment_request.dart';
import 'package:grc/features/compensation/domain/models/bulk_adjustments/employee_eligible_plans.dart';
import 'package:grc/features/compensation/domain/repositories/bulk_adjustments/bulk_adjustments_repository.dart';

class BulkAdjustmentsRepositoryImpl implements BulkAdjustmentsRepository {
  BulkAdjustmentsRepositoryImpl({required this.remoteDataSource});

  final BulkAdjustmentsRemoteDataSource remoteDataSource;

  @override
  Future<BulkEmployeeComponentsPage> getBulkEmployeeComponents({
    required int enterpriseId,
    required List<String> employeeGuids,
    required int page,
    required int pageSize,
  }) async {
    final dto = await remoteDataSource.getBulkEmployeeComponents(
      enterpriseId: enterpriseId,
      employeeGuids: employeeGuids,
      page: page,
      pageSize: pageSize,
    );
    return dto.toDomain();
  }

  @override
  Future<List<EmployeeEligiblePlans>> getEligiblePlans({required List<String> employeeGuids}) async {
    final dto = await remoteDataSource.getEligiblePlans(employeeGuids: employeeGuids);
    return dto.toDomain();
  }

  @override
  Future<void> createBulkAdjustment({required CreateBulkAdjustmentRequest request}) {
    return remoteDataSource.createBulkAdjustment(request: request);
  }
}
