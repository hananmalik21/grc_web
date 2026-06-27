import '../../domain/models/adjustments/adjustments_page.dart';
import '../../domain/models/adjustments/employee_component_history.dart';
import '../../domain/repositories/adjustments_repository.dart';
import '../datasources/remote/adjustments_remote_datasource.dart';

class AdjustmentsRepositoryImpl implements AdjustmentsRepository {
  final AdjustmentsRemoteDataSource remoteDataSource;

  AdjustmentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AdjustmentsPage> getAdjustments({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  }) async {
    final responseDto = await remoteDataSource.getAdjustments(
      enterpriseId: enterpriseId,
      page: page,
      limit: limit,
      searchQuery: searchQuery,
      status: status,
      department: department,
      region: region,
    );

    return AdjustmentsPage(
      adjustments: responseDto.data.map((e) => e.toDomain()).toList(),
      total: responseDto.pagination.total,
      page: responseDto.pagination.page,
      limit: responseDto.pagination.limit,
      totalPages: responseDto.pagination.totalPages,
      hasNext: responseDto.pagination.hasNext,
      hasPrevious: responseDto.pagination.hasPrevious,
    );
  }

  @override
  Future<List<EmployeeComponentHistory>> getEmployeeLatestComponentHistory({
    required int enterpriseId,
    required int employeeId,
  }) async {
    final dtos = await remoteDataSource.getEmployeeLatestComponentHistory(
      enterpriseId: enterpriseId,
      employeeId: employeeId,
    );
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
