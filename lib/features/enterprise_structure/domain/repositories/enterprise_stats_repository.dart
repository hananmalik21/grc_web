import 'package:grc/features/enterprise_structure/domain/models/enterprise_stats.dart';

abstract class EnterpriseStatsRepository {
  Future<EnterpriseStats> getEnterpriseStats({required int enterpriseId});
}
