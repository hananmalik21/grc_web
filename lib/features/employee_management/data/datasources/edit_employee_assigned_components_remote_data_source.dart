import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';

abstract class EditEmployeeAssignedComponentsRemoteDataSource {
  Future<List<Map<String, dynamic>>> getAssignedComponents({required String employeeGuid});
}

class EditEmployeeAssignedComponentsRemoteDataSourceImpl implements EditEmployeeAssignedComponentsRemoteDataSource {
  EditEmployeeAssignedComponentsRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<List<Map<String, dynamic>>> getAssignedComponents({required String employeeGuid}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.compEmployeeAssignedComponents,
        queryParameters: {'employee_guid': employeeGuid},
      );

      final success = response['status'] as bool? ?? response['success'] as bool? ?? false;
      if (!success) {
        final message = response['message'] as String? ?? 'Failed to fetch assigned components';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>?;
      return data?.map((item) => item as Map<String, dynamic>).toList() ?? [];
    } on AppException {
      rethrow;
    } catch (error) {
      throw UnknownException('Failed to fetch assigned components: $error', originalError: error);
    }
  }
}
