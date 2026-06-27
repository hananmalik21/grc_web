import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/workforce_structure/data/dto/paginated_employees_dto.dart';

abstract class EmployeeRemoteDataSource {
  Future<PaginatedEmployeesDto> getEmployees({
    required int enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  });
}

class EmployeeRemoteDataSourceImpl implements EmployeeRemoteDataSource {
  final ApiClient apiClient;

  EmployeeRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedEmployeesDto> getEmployees({
    required int enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };

      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      final response = await apiClient.get(ApiEndpoints.employees, queryParameters: queryParameters);

      return PaginatedEmployeesDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch employees: ${e.toString()}', originalError: e);
    }
  }
}
