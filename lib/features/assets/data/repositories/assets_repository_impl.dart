import 'package:dio/dio.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/assets/data/data_sources/assets_remote_data_source.dart';
import 'package:grc_web/features/assets/domain/entities/asset_entities.dart';
import 'package:grc_web/features/assets/domain/repositories/assets_repository.dart';

class AssetsRepositoryImpl implements AssetsRepository {
  const AssetsRepositoryImpl(this._remote);

  final AssetsRemoteDataSource _remote;

  @override
  Future<Result<AssetsData>> getAssets() async {
    try {
      final data = await _remote.getAssets();
      return Success(data);
    } on DioException catch (e) {
      return FailureResult(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (_) {
      return const FailureResult(UnknownFailure(message: 'Unknown error'));
    }
  }
}
