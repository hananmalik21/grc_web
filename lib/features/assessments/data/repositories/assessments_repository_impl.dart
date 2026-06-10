import 'package:dio/dio.dart';
import 'package:grc_web/core/errors/failure.dart';
import 'package:grc_web/core/errors/result.dart';
import 'package:grc_web/features/assessments/data/data_sources/assessments_remote_data_source.dart';
import 'package:grc_web/features/assessments/domain/entities/assessment_entities.dart';
import 'package:grc_web/features/assessments/domain/repositories/assessments_repository.dart';

class AssessmentsRepositoryImpl implements AssessmentsRepository {
  const AssessmentsRepositoryImpl(this._remote);

  final AssessmentsRemoteDataSource _remote;

  @override
  Future<Result<AssessmentsData>> getAssessments() async {
    try {
      final data = await _remote.getAssessments();
      return Success(data);
    } on DioException catch (e) {
      return FailureResult(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (_) {
      return const FailureResult(UnknownFailure(message: 'Unknown error'));
    }
  }

  @override
  Future<Result<FrameworkDetail>> getFrameworkDetail(String frameworkName) async {
    try {
      final data = await _remote.getFrameworkDetail(frameworkName);
      return Success(data);
    } on DioException catch (e) {
      return FailureResult(NetworkFailure(message: e.message ?? 'Network error'));
    } catch (_) {
      return const FailureResult(UnknownFailure(message: 'Unknown error'));
    }
  }
}
