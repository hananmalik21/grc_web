import 'package:grc/features/workforce_structure/domain/models/workforce_stats.dart';

abstract class WorkforceStatsRepository {
  Future<WorkforceStats> getWorkforceStats({int? tenantId});
}
