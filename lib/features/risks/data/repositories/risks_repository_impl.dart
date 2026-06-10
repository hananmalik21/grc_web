import 'package:dio/dio.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/risks/data/data_sources/risks_remote_data_source.dart';
import 'package:grc_web/features/risks/domain/entities/risk_entities.dart';
import 'package:grc_web/features/risks/domain/repositories/risks_repository.dart';

class RisksRepositoryImpl implements RisksRepository {
  const RisksRepositoryImpl(this._remote);

  final RisksRemoteDataSource _remote;

  @override
  Future<Result<RisksData>> getRisks() async {
    try {
      final data = await _remote.getRisks();
      return Success(data);
    } on DioException catch (e) {
      return FailureResult(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (_) {
      return const FailureResult(UnknownFailure(message: 'Unknown error'));
    }
  }
}
