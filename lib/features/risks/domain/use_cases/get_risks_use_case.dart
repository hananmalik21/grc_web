import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/risks/domain/entities/risk_entities.dart';
import 'package:grc_web/features/risks/domain/repositories/risks_repository.dart';

class GetRisksUseCase {
  const GetRisksUseCase(this._repository);

  final RisksRepository _repository;

  Future<Result<RisksData>> call() => _repository.getRisks();
}
