import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/dashboard/domain/entities/dashboard_data.dart';
import 'package:grc_web/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardDataUseCase {
  const GetDashboardDataUseCase(this._repository);

  final DashboardRepository _repository;

  Future<Result<DashboardData>> call() {
    return _repository.getDashboardData();
  }
}
