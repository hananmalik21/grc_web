import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/department_dto.dart';

/// Remote data source for department operations
abstract class DepartmentRemoteDataSource {
  Future<PaginatedDepartmentsDto> getDepartments({
    String? search,
    int page = 1,
    int pageSize = 10,
  });
  Future<DepartmentDto> createDepartment(Map<String, dynamic> departmentData);
  Future<DepartmentDto> updateDepartment(int departmentId, Map<String, dynamic> departmentData);
  Future<void> deleteDepartment(int departmentId, {bool hard = true});
}

class DepartmentRemoteDataSourceImpl implements DepartmentRemoteDataSource {
  final ApiClient apiClient;

  DepartmentRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaginatedDepartmentsDto> getDepartments({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      // Build query parameters
      final queryParameters = <String, String>{
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (search != null && search.trim().isNotEmpty) {
        queryParameters['search'] = search.trim();
      }

      final response = await apiClient.get(
        ApiEndpoints.departments,
        queryParameters: queryParameters,
      );

      return PaginatedDepartmentsDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch departments: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<DepartmentDto> createDepartment(Map<String, dynamic> departmentData) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.departments,
        body: departmentData,
      );

      // Handle different response formats
      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return DepartmentDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create department: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<DepartmentDto> updateDepartment(int departmentId, Map<String, dynamic> departmentData) async {
    try {
      final response = await apiClient.put(
        '${ApiEndpoints.departments}/$departmentId',
        body: departmentData,
      );

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return DepartmentDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update department: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteDepartment(int departmentId, {bool hard = true}) async {
    try {
      await apiClient.delete(
        '${ApiEndpoints.departments}/$departmentId',
        queryParameters: {'hard': hard.toString()},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete department: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

