import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/risks/domain/entities/risk_entities.dart';

abstract class RisksRepository {
  Future<Result<RisksData>> getRisks();
}
