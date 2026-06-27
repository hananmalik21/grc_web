import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/dto/employees/employee_compensation_list_dto.dart';

abstract class EmployeeCompensationRemoteDataSource {
  Future<EmployeeCompensationListDto> getEmployeeCompensations({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  });
}

class EmployeeCompensationRemoteDataSourceImpl implements EmployeeCompensationRemoteDataSource {
  const EmployeeCompensationRemoteDataSourceImpl({required this.apiClient});

  final ApiClient apiClient;

  @override
  Future<EmployeeCompensationListDto> getEmployeeCompensations({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      final normalizedSearch = search?.trim();
      if (normalizedSearch != null && normalizedSearch.isNotEmpty) {
        queryParameters['search'] = normalizedSearch;
      }

      final response = await apiClient.get(ApiEndpoints.compEmployeeCompensations, queryParameters: queryParameters);

      final success = response['status'] as bool? ?? response['success'] as bool? ?? false;
      if (!success) {
        final message = response['message'] as String? ?? 'Failed to fetch employee compensations';
        throw ServerException(message, statusCode: 400);
      }

      return EmployeeCompensationListDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employee compensations: ${e.toString()}', originalError: e);
    }
  }
}
