import 'package:dio/dio.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:grc_web/features/auth/domain/entities/app_user.dart';
import 'package:grc_web/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<Result<AppUser>> getCurrentUser() async {
    try {
      final dto = await _remote.getCurrentUser();
      return Success(dto.toEntity());
    } on DioException catch (e) {
      return FailureResult(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (_) {
      return const FailureResult(UnknownFailure(message: 'Unknown error'));
    }
  }
}

