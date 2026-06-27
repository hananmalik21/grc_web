import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/dto/leave_type_dto.dart';

abstract class LeaveTypesRemoteDataSource {
  Future<List<LeaveTypeDto>> getLeaveTypes({String? search, int? tenantId});
}

class LeaveTypesRemoteDataSourceImpl implements LeaveTypesRemoteDataSource {
  final ApiClient apiClient;

  LeaveTypesRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _buildHeaders() {
    return {'x-user-id': 'admin'};
  }

  @override
  Future<List<LeaveTypeDto>> getLeaveTypes({String? search, int? tenantId}) async {
    try {
      final queryParameters = <String, String>{};
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (tenantId != null) {
        queryParameters['tenant_id'] = tenantId.toString();
      }

      final response = await apiClient.get(
        ApiEndpoints.absLeaveTypes,
        queryParameters: queryParameters,
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch leave types';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>?;
      if (data == null) {
        return [];
      }

      return data.map((json) => LeaveTypeDto.fromJson(json as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch leave types: ${e.toString()}', originalError: e);
    }
  }
}
