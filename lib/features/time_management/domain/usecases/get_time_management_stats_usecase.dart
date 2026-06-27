import 'package:grc/features/time_management/domain/models/time_management_stats.dart';
import 'package:grc/features/time_management/domain/repositories/time_management_stats_repository.dart';

class GetTimeManagementStatsUseCase {
  final TimeManagementStatsRepository repository;

  const GetTimeManagementStatsUseCase({required this.repository});

  Future<TimeManagementStats> call({required int enterpriseId}) async {
    return await repository.getTimeManagementStats(enterpriseId: enterpriseId);
  }
}
