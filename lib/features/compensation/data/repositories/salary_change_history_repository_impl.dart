import '../../domain/models/adjustments/salary_change_history.dart';
import '../../domain/repositories/salary_change_history_repository.dart';
import '../datasources/remote/salary_change_history_remote_datasource.dart';

class SalaryChangeHistoryRepositoryImpl implements SalaryChangeHistoryRepository {
  final SalaryChangeHistoryRemoteDataSource remoteDataSource;

  SalaryChangeHistoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SalaryChangeHistoryPage> getSalaryChangeHistory({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  }) async {
    final responseDto = await remoteDataSource.getSalaryChangeHistory(
      enterpriseId: enterpriseId,
      page: page,
      limit: limit,
      searchQuery: searchQuery,
      status: status,
      department: department,
      region: region,
    );

    return responseDto.toDomain();
  }
}
