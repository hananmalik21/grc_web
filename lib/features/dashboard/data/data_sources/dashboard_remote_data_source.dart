import 'package:grc_web/features/dashboard/domain/entities/dashboard_data.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardData> getDashboardData();
}
