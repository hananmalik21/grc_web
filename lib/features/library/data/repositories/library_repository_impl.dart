import 'package:dio/dio.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/library/data/data_sources/library_remote_data_source.dart';
import 'package:grc_web/features/library/domain/entities/library_entities.dart';
import 'package:grc_web/features/library/domain/repositories/library_repository.dart';

class LibraryRepositoryImpl implements LibraryRepository {
  const LibraryRepositoryImpl(this._remote);

  final LibraryRemoteDataSource _remote;

  @override
  Future<Result<LibraryData>> getLibrary() async {
    try {
      final data = await _remote.getLibrary();
      return Success(data);
    } on DioException catch (e) {
      return FailureResult(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (_) {
      return const FailureResult(UnknownFailure(message: 'Unknown error'));
    }
  }
}

