import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';
import 'package:grc/features/time_management/domain/models/schedule_assignment.dart';

abstract class ScheduleAssignmentRemoteDataSource {
  Future<PaginatedScheduleAssignments> getScheduleAssignments({required int tenantId, int page = 1, int pageSize = 10});
  Future<ScheduleAssignment> createScheduleAssignment({
    required int tenantId,
    required Map<String, dynamic> assignmentData,
  });
  Future<ScheduleAssignment> updateScheduleAssignment({
    required int scheduleAssignmentId,
    required int tenantId,
    required Map<String, dynamic> assignmentData,
  });
  Future<void> deleteScheduleAssignment({required int scheduleAssignmentId, required int tenantId, bool hard = true});
}

class ScheduleAssignmentRemoteDataSourceImpl implements ScheduleAssignmentRemoteDataSource {
  final ApiClient apiClient;

  const ScheduleAssignmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedScheduleAssignments> getScheduleAssignments({
    required int tenantId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      if (page < 1) {
        throw ValidationException('page must be greater than or equal to 1');
      }

      if (pageSize < 1 || pageSize > 100) {
        throw ValidationException('page_size must be between 1 and 100');
      }

      final queryParameters = <String, String>{'tenant_id': tenantId.toString()};

      final response = await apiClient.get(ApiEndpoints.tmScheduleAssignments, queryParameters: queryParameters);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      final dataJson = response['data'] as List<dynamic>? ?? [];
      final scheduleAssignments = dataJson
          .map((item) {
            try {
              return ScheduleAssignment.fromJson(item as Map<String, dynamic>);
            } catch (e) {
              return null;
            }
          })
          .whereType<ScheduleAssignment>()
          .toList();

      final metaJson = response['meta'] as Map<String, dynamic>? ?? {};
      final paginationJson = metaJson['pagination'] as Map<String, dynamic>? ?? {};

      int parseInt(dynamic value, {int defaultValue = 0}) {
        if (value == null) return defaultValue;
        if (value is int) return value;
        if (value is String) {
          final parsed = int.tryParse(value);
          return parsed ?? defaultValue;
        }
        if (value is num) return value.toInt();
        return defaultValue;
      }

      final paginationPage = parseInt(paginationJson['page'], defaultValue: 1);
      final paginationPageSize = parseInt(paginationJson['limit'], defaultValue: pageSize);
      final paginationTotal = parseInt(paginationJson['total'], defaultValue: 0);

      final validPage = paginationPage < 1 ? 1 : paginationPage;
      final validPageSize = paginationPageSize < 1 ? pageSize : paginationPageSize;
      final validTotal = paginationTotal < 0 ? 0 : paginationTotal;
      final validTotalPages = validPageSize > 0 ? (validTotal / validPageSize).ceil() : 0;

      final pagination = PaginationInfo(
        currentPage: validPage,
        totalPages: validTotalPages,
        totalItems: validTotal,
        pageSize: validPageSize,
        hasNext: validPage < validTotalPages,
        hasPrevious: validPage > 1,
      );

      return PaginatedScheduleAssignments(scheduleAssignments: scheduleAssignments, pagination: pagination);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
    } catch (e) {
      throw UnknownException('Failed to fetch schedule assignments: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<ScheduleAssignment> createScheduleAssignment({
    required int tenantId,
    required Map<String, dynamic> assignmentData,
  }) async {
    try {
      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final response = await apiClient.post(ApiEndpoints.tmScheduleAssignments, body: assignmentData);

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      final dataJson = response['data'] as Map<String, dynamic>? ?? response;
      return ScheduleAssignment.fromJson(dataJson);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
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
        throw ValidationException('schedule_assignment_id must be greater than 0');
      }

      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final response = await apiClient.patch(
        ApiEndpoints.tmScheduleAssignmentById(scheduleAssignmentId),
        body: assignmentData,
      );

      if (response.isEmpty) {
        throw UnknownException('Empty response from server');
      }

      final dataJson = response['data'] as Map<String, dynamic>? ?? response;
      return ScheduleAssignment.fromJson(dataJson);
    } on AppException {
      rethrow;
    } on FormatException catch (e) {
      throw ValidationException('Invalid data format: ${e.message}', originalError: e);
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
        throw ValidationException('schedule_assignment_id must be greater than 0');
      }

      if (tenantId <= 0) {
        throw ValidationException('tenant_id must be greater than 0');
      }

      final queryParameters = <String, String>{'tenant_id': tenantId.toString(), 'hard': hard.toString()};

      await apiClient.delete(
        ApiEndpoints.tmScheduleAssignmentById(scheduleAssignmentId),
        queryParameters: queryParameters,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete schedule assignment: ${e.toString()}', originalError: e);
    }
  }
}
