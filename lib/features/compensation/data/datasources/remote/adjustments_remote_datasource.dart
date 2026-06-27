import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import '../../dto/adjustments/adjustment_dto.dart';
import '../../dto/adjustments/employee_component_history_dto.dart';

abstract class AdjustmentsRemoteDataSource {
  Future<AdjustmentResponseDto> getAdjustments({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  });

  Future<List<EmployeeComponentHistoryDto>> getEmployeeLatestComponentHistory({
    required int enterpriseId,
    required int employeeId,
  });
}

class AdjustmentsRemoteDataSourceImpl implements AdjustmentsRemoteDataSource {
  final ApiClient apiClient;

  AdjustmentsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AdjustmentResponseDto> getAdjustments({
    required int enterpriseId,
    required int page,
    required int limit,
    String? searchQuery,
    String? status,
    String? department,
    String? region,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParameters['search'] = searchQuery;
      }
      if (status != null && status != 'All Status') {
        queryParameters['status'] = status;
      }
      if (department != null && department != 'All Departments') {
        queryParameters['department'] = department;
      }
      if (region != null && region != 'All Regions') {
        queryParameters['region'] = region;
      }

      // The endpoint from user: /api/comp/adjustments
      final response = await apiClient.get('/api/comp/adjustments', queryParameters: queryParameters);

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch adjustments';
        throw ServerException(message, statusCode: 400);
      }

      return AdjustmentResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch adjustments: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<EmployeeComponentHistoryDto>> getEmployeeLatestComponentHistory({
    required int enterpriseId,
    required int employeeId,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.compEmployeeLatestComponentHistory,
        queryParameters: {'enterprise_id': enterpriseId.toString(), 'employee_id': employeeId.toString()},
      );

      final status = response['status'] as bool? ?? false;
      if (!status) {
        final message = response['message'] as String? ?? 'Failed to fetch history';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>? ?? [];
      return data.whereType<Map<String, dynamic>>().map(EmployeeComponentHistoryDto.fromJson).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employee component history: ${e.toString()}', originalError: e);
    }
  }
}
