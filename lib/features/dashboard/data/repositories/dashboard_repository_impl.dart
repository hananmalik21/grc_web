import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/dashboard/data/data_sources/dashboard_remote_data_source.dart';
import 'package:grc_web/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:grc_web/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  const DashboardRepositoryImpl(this._dataSource);

  final DashboardRemoteDataSource _dataSource;

  @override
  Future<Result<DashboardData>> getDashboardData() async {
    try {
      final data = await _dataSource.getDashboardData();
      return Success(data);
    } catch (e) {
      return FailureResult(NetworkFailure(message: e.toString()));
    }
  }
}
