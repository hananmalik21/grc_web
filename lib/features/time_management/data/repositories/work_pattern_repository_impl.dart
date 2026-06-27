import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/data/datasources/work_pattern_remote_datasource.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';
import 'package:grc/features/time_management/domain/repositories/work_pattern_repository.dart';

class WorkPatternRepositoryImpl implements WorkPatternRepository {
  final WorkPatternRemoteDataSource remoteDataSource;
  final int tenantId;

  const WorkPatternRepositoryImpl({required this.remoteDataSource, required this.tenantId});

  @override
  Future<PaginatedWorkPatterns> getWorkPatterns({int page = 1, int pageSize = 10}) async {
    try {
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('pageSize must be between 1 and 100');
      }

      return await remoteDataSource.getWorkPatterns(tenantId: tenantId, page: page, pageSize: pageSize);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get work patterns: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<WorkPattern> createWorkPattern({
    required String patternCode,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  }) async {
    try {
      return await remoteDataSource.createWorkPattern(
        tenantId: tenantId,
        patternCode: patternCode,
        patternNameEn: patternNameEn,
        patternNameAr: patternNameAr,
        patternType: patternType,
        totalHoursPerWeek: totalHoursPerWeek,
        status: status,
        days: days,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create work pattern: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<WorkPattern> updateWorkPattern({
    required int workPatternId,
    required String patternNameEn,
    required String patternNameAr,
    required String patternType,
    required int totalHoursPerWeek,
    required PositionStatus status,
    required List<WorkPatternDay> days,
  }) async {
    try {
      return await remoteDataSource.updateWorkPattern(
        workPatternId: workPatternId,
        tenantId: tenantId,
        patternNameEn: patternNameEn,
        patternNameAr: patternNameAr,
        patternType: patternType,
        totalHoursPerWeek: totalHoursPerWeek,
        status: status,
        days: days,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update work pattern: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteWorkPattern({required int workPatternId, required bool hard}) async {
    try {
      return await remoteDataSource.deleteWorkPattern(workPatternId: workPatternId, tenantId: tenantId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete work pattern: ${e.toString()}', originalError: e);
    }
  }
}
