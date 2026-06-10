import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';

abstract class AssetsRemoteDataSource {
  Future<AssetsData> getAssets();
}
