import 'package:grc/features/time_management/domain/models/time_management_stats.dart';

abstract class TimeManagementStatsRepository {
  Future<TimeManagementStats> getTimeManagementStats({required int enterpriseId});
}
