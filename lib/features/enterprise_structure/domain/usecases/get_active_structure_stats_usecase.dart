import 'package:grc/features/enterprise_structure/domain/models/active_structure_stats.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/active_structure_stats_repository.dart';

class GetActiveStructureStatsUseCase {
  final ActiveStructureStatsRepository repository;

  const GetActiveStructureStatsUseCase({required this.repository});

  Future<ActiveStructureStats> call({required int enterpriseId}) async {
    return await repository.getActiveStructureStats(enterpriseId: enterpriseId);
  }
}
