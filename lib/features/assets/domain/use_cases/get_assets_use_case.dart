import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';
import 'package:grc_web/features/assets/domain/repositories/assets_repository.dart';

class GetAssetsUseCase {
  const GetAssetsUseCase(this._repository);

  final AssetsRepository _repository;

  Future<Result<AssetsData>> call() => _repository.getAssets();
}
