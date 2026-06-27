import 'dart:io';
import 'package:dio/dio.dart';
import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/dto/leave_request_stats_dto.dart';
import 'package:grc/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:grc/features/leave_management/data/mappers/leave_type_mapper.dart';
import 'package:grc/features/leave_management/domain/models/document.dart';
import 'package:grc/features/leave_management/presentation/providers/new_leave_request_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

abstract class LeaveRequestsRemoteDataSource {
  Future<PaginatedLeaveRequestsDto> getLeaveRequests({int page = 1, int pageSize = 10, String? status, int? tenantId});

  Future<PaginatedLeaveRequestsDto> getEmployeeLeaveRequests({
    required String employeeGuid,
    int page = 1,
    int pageSize = 10,
    int? tenantId,
  });

  Future<EmployeeLeaveStatsDto> getEmployeeLeaveRequestStats({required String employeeGuid, int? tenantId});

  Future<Map<String, dynamic>> getLeaveRequestById(String guid, {int? tenantId});

  Future<Map<String, dynamic>> approveLeaveRequest(String guid, {int? tenantId});

  Future<Map<String, dynamic>> rejectLeaveRequest(String guid, {int? tenantId});

  Future<Map<String, dynamic>> createLeaveRequest(NewLeaveRequestState state, bool submit, {int? tenantId});

  Future<Map<String, dynamic>> deleteLeaveRequest(String guid, {int? tenantId});

  Future<Map<String, dynamic>> updateLeaveRequest(
    String guid,
    NewLeaveRequestState state,
    bool submit, {
    int? tenantId,
  });
}

class LeaveRequestsRemoteDataSourceImpl implements LeaveRequestsRemoteDataSource {
  final ApiClient apiClient;

  LeaveRequestsRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _buildHeaders({int? tenantId}) {
    return {if (tenantId != null) 'x-tenant-id': tenantId.toString(), 'x-user-id': 'admin'};
  }

  @override
  Future<PaginatedLeaveRequestsDto> getLeaveRequests({
    int page = 1,
    int pageSize = 10,
    String? status,
    int? tenantId,
  }) async {
    try {
      final queryParameters = <String, String>{'page': page.toString(), 'page_size': pageSize.toString()};
      if (status != null && status.isNotEmpty) {
        queryParameters['status'] = status;
      }

      final response = await apiClient.get(
        ApiEndpoints.absLeaveRequests,
        queryParameters: queryParameters,
        headers: _buildHeaders(tenantId: tenantId),
      );

      return PaginatedLeaveRequestsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave requests: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<PaginatedLeaveRequestsDto> getEmployeeLeaveRequests({
    required String employeeGuid,
    int page = 1,
    int pageSize = 10,
    int? tenantId,
  }) async {
    try {
      final queryParameters = <String, String>{'page': page.toString(), 'page_size': pageSize.toString()};

      final response = await apiClient.get(
        ApiEndpoints.absEmployeeLeaveRequests(employeeGuid),
        queryParameters: queryParameters,
        headers: _buildHeaders(tenantId: tenantId),
      );

      return PaginatedLeaveRequestsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employee leave requests: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<EmployeeLeaveStatsDto> getEmployeeLeaveRequestStats({required String employeeGuid, int? tenantId}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.absEmployeeLeaveRequestStats(employeeGuid),
        headers: _buildHeaders(tenantId: tenantId),
      );
      final data = response['data'];
      if (data is List && data.isNotEmpty && data.first is Map<String, dynamic>) {
        return EmployeeLeaveStatsDto.fromJson(data.first as Map<String, dynamic>);
      }
      return EmployeeLeaveStatsDto.fromJson({});
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employee leave request stats: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> getLeaveRequestById(String guid, {int? tenantId}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.absLeaveRequestById(guid),
        headers: _buildHeaders(tenantId: tenantId),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch leave request';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> approveLeaveRequest(String guid, {int? tenantId}) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.absLeaveRequestApprove(guid),
        headers: _buildHeaders(tenantId: tenantId),
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to approve leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> rejectLeaveRequest(String guid, {int? tenantId}) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.absLeaveRequestReject(guid),
        headers: _buildHeaders(tenantId: tenantId),
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to reject leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> createLeaveRequest(NewLeaveRequestState state, bool submit, {int? tenantId}) async {
    try {
      if (state.selectedEmployee == null ||
          state.leaveType == null ||
          state.startDate == null ||
          state.endDate == null) {
        throw ValidationException(
          'Required fields are missing',
          errors: {
            'employee': 'Employee is required',
            'leaveType': 'Leave type is required',
            'startDate': 'Start date is required',
            'endDate': 'End date is required',
          },
        );
      }

      final formData = FormData();

      formData.fields.add(MapEntry('employee_guid', state.selectedEmployee!.guid));
      formData.fields.add(
        MapEntry('leave_type_id', (state.leaveTypeId ?? LeaveTypeMapper.getLeaveTypeId(state.leaveType!)).toString()),
      );
      formData.fields.add(MapEntry('start_date', _formatDate(state.startDate!)));
      formData.fields.add(MapEntry('end_date', _formatDate(state.endDate!)));

      final startPortion = _mapTimeToPortion(state.startTime);
      final endPortion = _mapTimeToPortion(state.endTime);
      formData.fields.add(MapEntry('start_portion', startPortion));
      formData.fields.add(MapEntry('end_portion', endPortion));

      if (state.delegatedToEmployeeId != null) {
        formData.fields.add(MapEntry('delegated_employee_id', state.delegatedToEmployeeId!.toString()));
      }

      if (state.reason != null && state.reason!.isNotEmpty) {
        formData.fields.add(MapEntry('reason_for_leave', state.reason!));
      }

      if (state.addressDuringLeave != null && state.addressDuringLeave!.isNotEmpty) {
        formData.fields.add(MapEntry('address_during_leave', state.addressDuringLeave!));
      }

      if (state.contactPhoneNumber != null && state.contactPhoneNumber!.isNotEmpty) {
        formData.fields.add(MapEntry('contact_phone', state.contactPhoneNumber!));
      }

      if (state.emergencyContactName != null && state.emergencyContactName!.isNotEmpty) {
        formData.fields.add(MapEntry('emergency_contact_name', state.emergencyContactName!));
      }

      if (state.emergencyContactPhone != null && state.emergencyContactPhone!.isNotEmpty) {
        formData.fields.add(MapEntry('emergency_contact_phone', state.emergencyContactPhone!));
      }

      if (state.additionalNotes != null && state.additionalNotes!.isNotEmpty) {
        formData.fields.add(MapEntry('additional_notes', state.additionalNotes!));
      }

      formData.fields.add(MapEntry('submit', submit.toString()));

      await _addDocumentsToFormData(formData, state.documents);

      final response = await apiClient.postMultipart(
        ApiEndpoints.absLeaveRequests,
        formData: formData,
        headers: _buildHeaders(tenantId: tenantId),
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create leave request: ${e.toString()}', originalError: e);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _mapTimeToPortion(String? time) {
    if (time == null || time.isEmpty) return 'FULL_DAY';
    return time.trim().toUpperCase();
  }

  Future<void> _addDocumentsToFormData(FormData formData, List<Document> documents) async {
    for (final document in documents) {
      if (document.bytes != null) {
        final multipartFile = MultipartFile.fromBytes(document.bytes!, filename: document.name);
        formData.files.add(MapEntry('documents', multipartFile));
      } else if (!kIsWeb) {
        final file = File(document.path);
        if (await file.exists()) {
          final multipartFile = await MultipartFile.fromFile(document.path, filename: document.name);
          formData.files.add(MapEntry('documents', multipartFile));
        }
      }
    }
  }

  @override
  Future<Map<String, dynamic>> deleteLeaveRequest(String guid, {int? tenantId}) async {
    try {
      final response = await apiClient.delete(
        ApiEndpoints.absLeaveRequestDelete(guid),
        headers: _buildHeaders(tenantId: tenantId),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to delete leave request';
        throw ServerException(message, statusCode: 400);
      }

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete leave request: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Map<String, dynamic>> updateLeaveRequest(
    String guid,
    NewLeaveRequestState state,
    bool submit, {
    int? tenantId,
  }) async {
    try {
      if (state.selectedEmployee == null ||
          state.leaveType == null ||
          state.startDate == null ||
          state.endDate == null) {
        throw ValidationException(
          'Required fields are missing',
          errors: {
            'employee': 'Employee is required',
            'leaveType': 'Leave type is required',
            'startDate': 'Start date is required',
            'endDate': 'End date is required',
          },
        );
      }

      final formData = FormData();

      formData.fields.add(MapEntry('employee_guid', state.selectedEmployee!.guid));
      formData.fields.add(
        MapEntry('leave_type_id', (state.leaveTypeId ?? LeaveTypeMapper.getLeaveTypeId(state.leaveType!)).toString()),
      );
      formData.fields.add(MapEntry('start_date', _formatDate(state.startDate!)));
      formData.fields.add(MapEntry('end_date', _formatDate(state.endDate!)));

      final startPortion = _mapTimeToPortion(state.startTime);
      final endPortion = _mapTimeToPortion(state.endTime);
      formData.fields.add(MapEntry('start_portion', startPortion));
      formData.fields.add(MapEntry('end_portion', endPortion));

      if (state.delegatedToEmployeeId != null) {
        formData.fields.add(MapEntry('delegated_employee_id', state.delegatedToEmployeeId!.toString()));
      }

      if (state.reason != null && state.reason!.isNotEmpty) {
        formData.fields.add(MapEntry('reason_for_leave', state.reason!));
      }

      if (state.addressDuringLeave != null && state.addressDuringLeave!.isNotEmpty) {
        formData.fields.add(MapEntry('address_during_leave', state.addressDuringLeave!));
      }

      if (state.contactPhoneNumber != null && state.contactPhoneNumber!.isNotEmpty) {
        formData.fields.add(MapEntry('contact_phone', state.contactPhoneNumber!));
      }

      if (state.emergencyContactName != null && state.emergencyContactName!.isNotEmpty) {
        formData.fields.add(MapEntry('emergency_contact_name', state.emergencyContactName!));
      }

      if (state.emergencyContactPhone != null && state.emergencyContactPhone!.isNotEmpty) {
        formData.fields.add(MapEntry('emergency_contact_phone', state.emergencyContactPhone!));
      }

      if (state.additionalNotes != null && state.additionalNotes!.isNotEmpty) {
        formData.fields.add(MapEntry('additional_notes', state.additionalNotes!));
      }

      formData.fields.add(MapEntry('submit', submit.toString()));

      await _addDocumentsToFormData(formData, state.documents);

      final response = await apiClient.putMultipart(
        ApiEndpoints.absLeaveRequestUpdate(guid),
        formData: formData,
        headers: _buildHeaders(tenantId: tenantId),
      );

      return response;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update leave request: ${e.toString()}', originalError: e);
    }
  }
}
