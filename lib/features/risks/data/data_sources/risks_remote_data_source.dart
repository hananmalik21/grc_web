import 'package:grc_web/features/risks/domain/entities/risk_entities.dart';

abstract class RisksRemoteDataSource {
  Future<RisksData> getRisks();
}
