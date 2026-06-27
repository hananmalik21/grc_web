import 'package:grc/features/enterprise_structure/domain/models/enterprise_stats.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/enterprise_stats_repository.dart';

class GetEnterpriseStatsUseCase {
  final EnterpriseStatsRepository repository;

  const GetEnterpriseStatsUseCase({required this.repository});

  Future<EnterpriseStats> call({required int enterpriseId}) async {
    return await repository.getEnterpriseStats(enterpriseId: enterpriseId);
  }
}
