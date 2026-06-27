import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/create_overtime_request_dto.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/overtime_requests_dto.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/update_overtime_request_dto.dart';

abstract class OvertimeRequestsRemoteDataSource {
  Future<void> createOvertimeRequest(CreateOvertimeRequestDto dto);

  Future<Map<String, dynamic>?> updateOvertimeRequest(String otRequestGuid, {required UpdateOvertimeRequestDto dto});

  Future<Map<String, dynamic>?> cancelOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  });

  Future<Map<String, dynamic>?> approveOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  });

  Future<Map<String, dynamic>?> rejectOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  });

  Future<OvertimeRequestsResponseDto> getOvertimeRequests({
    required int tenantId,
    String? status,
    String? searchQuery,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  });
}

class OvertimeRequestsRemoteDataSourceImpl implements OvertimeRequestsRemoteDataSource {
  final ApiClient apiClient;

  OvertimeRequestsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<void> createOvertimeRequest(CreateOvertimeRequestDto dto) async {
    try {
      await apiClient.post(ApiEndpoints.tmOvertimeRequests, body: dto.toJson());
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create overtime request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>?> updateOvertimeRequest(
    String otRequestGuid, {
    required UpdateOvertimeRequestDto dto,
  }) async {
    try {
      final response = await apiClient.patch(ApiEndpoints.tmOvertimeRequestById(otRequestGuid), body: dto.toJson());
      return response['data'] as Map<String, dynamic>?;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update overtime request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>?> cancelOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.tmOvertimeRequestCancel(otRequestGuid),
        body: {'tenant_id': tenantId, 'actor': actor},
      );
      return response['data'] as Map<String, dynamic>?;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to cancel overtime request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>?> approveOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.tmOvertimeRequestApprove(otRequestGuid),
        body: {'tenant_id': tenantId, 'actor': actor},
      );
      return response['data'] as Map<String, dynamic>?;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to approve overtime request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>?> rejectOvertimeRequest(
    String otRequestGuid, {
    required int tenantId,
    String actor = 'manager.user',
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.tmOvertimeRequestReject(otRequestGuid),
        body: {'tenant_id': tenantId, 'actor': actor},
      );
      return response['data'] as Map<String, dynamic>?;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to reject overtime request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<OvertimeRequestsResponseDto> getOvertimeRequests({
    required int tenantId,
    String? status,
    String? searchQuery,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'tenant_id': tenantId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }
      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        queryParameters['search'] = searchQuery.trim();
      }
      if (orgUnitId != null && orgUnitId.isNotEmpty) {
        queryParameters['org_unit_id'] = orgUnitId;
      }
      if (levelCode != null && levelCode.isNotEmpty) {
        queryParameters['level_code'] = levelCode;
      }

      final response = await apiClient.get(ApiEndpoints.tmOvertimeRequests, queryParameters: queryParameters);

      return OvertimeRequestsResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch overtime requests: ${e.toString()}', originalError: e);
    }
  }
}
