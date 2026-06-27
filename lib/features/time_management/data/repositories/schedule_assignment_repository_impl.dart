import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/data/datasources/schedule_assignment_remote_datasource.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';
import 'package:grc/features/time_management/domain/repositories/schedule_assignment_repository.dart';

class ScheduleAssignmentRepositoryImpl implements ScheduleAssignmentRepository {
  final ScheduleAssignmentRemoteDataSource remoteDataSource;
  final int tenantId;

  const ScheduleAssignmentRepositoryImpl({required this.remoteDataSource, required this.tenantId});

  @override
  Future<PaginatedScheduleAssignments> getScheduleAssignments({
    required int tenantId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('pageSize must be between 1 and 100');
      }

      return await remoteDataSource.getScheduleAssignments(tenantId: tenantId, page: page, pageSize: pageSize);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get schedule assignments: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ScheduleAssignment> createScheduleAssignment({
    required int tenantId,
    required Map<String, dynamic> assignmentData,
  }) async {
    try {
      if (tenantId <= 0) {
        throw ValidationException('tenantId must be greater than 0');
      }

      return await remoteDataSource.createScheduleAssignment(tenantId: tenantId, assignmentData: assignmentData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create schedule assignment: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ScheduleAssignment> updateScheduleAssignment({
    required int scheduleAssignmentId,
    required int tenantId,
    required Map<String, dynamic> assignmentData,
  }) async {
    try {
      if (scheduleAssignmentId <= 0) {
        throw ValidationException('scheduleAssignmentId must be greater than 0');
      }

      if (tenantId <= 0) {
        throw ValidationException('tenantId must be greater than 0');
      }

      return await remoteDataSource.updateScheduleAssignment(
        scheduleAssignmentId: scheduleAssignmentId,
        tenantId: tenantId,
        assignmentData: assignmentData,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update schedule assignment: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteScheduleAssignment({
    required int scheduleAssignmentId,
    required int tenantId,
    bool hard = true,
  }) async {
    try {
      if (scheduleAssignmentId <= 0) {
        throw ValidationException('scheduleAssignmentId must be greater than 0');
      }

      if (tenantId <= 0) {
        throw ValidationException('tenantId must be greater than 0');
      }

      return await remoteDataSource.deleteScheduleAssignment(
        scheduleAssignmentId: scheduleAssignmentId,
        tenantId: tenantId,
        hard: hard,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete schedule assignment: ${e.toString()}', originalError: e);
    }
  }
}
