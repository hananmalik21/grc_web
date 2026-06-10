import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';

abstract class AssetsRepository {
  Future<Result<AssetsData>> getAssets();
}
