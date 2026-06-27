import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/function_role.dart';
import 'package:grc/features/security_manager/domain/repositories/function_roles_repository.dart';

class FunctionRolesRepositoryImpl implements FunctionRolesRepository {
  const FunctionRolesRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<void> deleteFunctionRole({required String functionRoleGuid, required int enterpriseId}) async {
    try {
      await _client.delete(
        ApiEndpoints.securityFunctionRoleByGuid(functionRoleGuid),
        queryParameters: {'enterprise_id': enterpriseId.toString()},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete function role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<FunctionRolePage> getFunctionRoles({
    required int enterpriseId,
    String? search,
    int? moduleId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final params = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.clamp(1, 10).toString(),
      };
      if (search != null && search.isNotEmpty) params['search'] = search;
      if (moduleId != null) params['module_id'] = moduleId.toString();
      final response = await _client.get(ApiEndpoints.securityFunctionRoles, queryParameters: params);
      final data = response['data'] as List<dynamic>? ?? [];
      final roles = data.map((item) => FunctionRole.fromJson(item as Map<String, dynamic>)).toList();

      final pagination =
          (response['pagination'] as Map<String, dynamic>?) ??
          ((response['meta'] as Map<String, dynamic>?)?['pagination'] as Map<String, dynamic>?);

      return FunctionRolePage(
        roles: roles,
        page: (pagination?['page'] as num?)?.toInt() ?? page,
        pageSize: (pagination?['pageSize'] as num?)?.toInt() ?? (pagination?['page_size'] as num?)?.toInt() ?? pageSize,
        total: (pagination?['total'] as num?)?.toInt() ?? roles.length,
        totalPages: (pagination?['totalPages'] as num?)?.toInt() ?? (pagination?['total_pages'] as num?)?.toInt() ?? 1,
        hasNext: (pagination?['hasNext'] as bool?) ?? (pagination?['has_next'] as bool?) ?? false,
        hasPrevious: (pagination?['hasPrevious'] as bool?) ?? (pagination?['has_previous'] as bool?) ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch function roles: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> createFunctionRole({
    required int enterpriseId,
    required int moduleId,
    required String roleCode,
    required String roleName,
    required String description,
    required String statusCode,
    required int displayOrder,
    required String activeFlag,
    required String isSystemFlag,
    required String startDate,
    required List<Map<String, dynamic>> functionsJson,
    required List<Map<String, dynamic>> inheritedRolesJson,
  }) async {
    try {
      await _client.post(
        ApiEndpoints.securityFunctionRoles,
        body: {
          'enterprise_id': enterpriseId,
          'module_id': moduleId,
          'role_code': roleCode,
          'role_name': roleName,
          'description': description,
          'status_code': statusCode,
          'display_order': displayOrder,
          'active_flag': activeFlag,
          'is_system_flag': isSystemFlag,
          'start_date': startDate,
          'end_date': null,
          'functions': functionsJson,
          'inherited_roles': inheritedRolesJson,
          'created_by': 'ADMIN',
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create function role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateFunctionRole({
    required String functionRoleGuid,
    required int enterpriseId,
    required int moduleId,
    required String roleCode,
    required String roleName,
    required String description,
    required String statusCode,
    required int displayOrder,
    required String activeFlag,
    required String isSystemFlag,
    required String startDate,
    required List<Map<String, dynamic>> functionsJson,
    required List<Map<String, dynamic>> inheritedRolesJson,
  }) async {
    try {
      await _client.put(
        ApiEndpoints.securityFunctionRoleByGuid(functionRoleGuid),
        body: {
          'enterprise_id': enterpriseId,
          'module_id': moduleId,
          'role_code': roleCode,
          'role_name': roleName,
          'description': description,
          'status_code': statusCode,
          'display_order': displayOrder,
          'active_flag': activeFlag,
          'is_system_flag': isSystemFlag,
          'start_date': startDate,
          'end_date': null,
          'functions': functionsJson,
          'inherited_roles': inheritedRolesJson,
          'last_updated_by': 'ADMIN',
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update function role: ${e.toString()}', originalError: e);
    }
  }
}
