import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/data/datasources/work_schedule_remote_datasource.dart';
import 'package:grc/features/time_management/domain/models/work_schedule.dart';
import 'package:grc/features/time_management/domain/repositories/work_schedule_repository.dart';

class WorkScheduleRepositoryImpl implements WorkScheduleRepository {
  final WorkScheduleRemoteDataSource remoteDataSource;
  final int tenantId;

  const WorkScheduleRepositoryImpl({required this.remoteDataSource, required this.tenantId});

  @override
  Future<PaginatedWorkSchedules> getWorkSchedules({int page = 1, int pageSize = 10}) async {
    try {
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('pageSize must be between 1 and 100');
      }

      return await remoteDataSource.getWorkSchedules(tenantId: tenantId, page: page, pageSize: pageSize);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get work schedules: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<WorkSchedule> createWorkSchedule({required Map<String, dynamic> data}) async {
    try {
      return await remoteDataSource.createWorkSchedule(data: data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create work schedule: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<WorkSchedule> updateWorkSchedule({required int scheduleId, required Map<String, dynamic> data}) async {
    try {
      return await remoteDataSource.updateWorkSchedule(scheduleId: scheduleId, data: data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update work schedule: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteWorkSchedule({required int scheduleId, bool hard = true}) async {
    try {
      return await remoteDataSource.deleteWorkSchedule(scheduleId: scheduleId, tenantId: tenantId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete work schedule: ${e.toString()}', originalError: e);
    }
  }
}
