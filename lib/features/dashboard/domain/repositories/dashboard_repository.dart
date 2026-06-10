import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/dashboard/domain/entities/dashboard_data.dart';

abstract class DashboardRepository {
  Future<Result<DashboardData>> getDashboardData();
}
