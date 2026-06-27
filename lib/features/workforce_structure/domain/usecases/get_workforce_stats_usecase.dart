import 'package:grc/features/workforce_structure/domain/models/workforce_stats.dart';
import 'package:grc/features/workforce_structure/domain/repositories/workforce_stats_repository.dart';

class GetWorkforceStatsUseCase {
  final WorkforceStatsRepository repository;

  const GetWorkforceStatsUseCase({required this.repository});

  Future<WorkforceStats> call({int? tenantId}) async {
    return await repository.getWorkforceStats(tenantId: tenantId);
  }
}
