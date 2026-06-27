import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/duty_role.dart';
import 'package:grc/features/security_manager/domain/repositories/duty_roles_repository.dart';

class DutyRolesRepositoryImpl implements DutyRolesRepository {
  const DutyRolesRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<DutyRolePage> getDutyRoles({
    required int enterpriseId,
    String? search,
    String? categoryCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.clamp(1, 10).toString(),
      };
      if (search != null && search.isNotEmpty) queryParameters['search'] = search;
      if (categoryCode != null && categoryCode.isNotEmpty) {
        queryParameters['category_code'] = categoryCode;
      }
      final response = await _client.get(ApiEndpoints.securityDutyRoles, queryParameters: queryParameters);
      final data = response['data'] as List<dynamic>? ?? [];
      final roles = data.map((item) => DutyRole.fromJson(item as Map<String, dynamic>)).toList();
      final pagination =
          ((response['meta'] as Map<String, dynamic>?)?['pagination'] as Map<String, dynamic>?) ??
          (response['pagination'] as Map<String, dynamic>?);
      return DutyRolePage(
        roles: roles,
        page: (pagination?['page'] as num?)?.toInt() ?? page,
        pageSize: (pagination?['page_size'] as num?)?.toInt() ?? (pagination?['pageSize'] as num?)?.toInt() ?? pageSize,
        total: (pagination?['total'] as num?)?.toInt() ?? (response['count'] as num?)?.toInt() ?? roles.length,
        totalPages: (pagination?['total_pages'] as num?)?.toInt() ?? (pagination?['totalPages'] as num?)?.toInt() ?? 1,
        hasNext: (pagination?['has_next'] as bool?) ?? (pagination?['hasNext'] as bool?) ?? false,
        hasPrevious: (pagination?['has_previous'] as bool?) ?? (pagination?['hasPrevious'] as bool?) ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch duty roles: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> createDutyRole({
    required int enterpriseId,
    required String name,
    required String code,
    required String categoryCode,
    required String status,
    required String description,
    required String requiresManagerApproval,
    required String activeFlag,
    required String actor,
    required List<Map<String, dynamic>> functionRoles,
    required List<Map<String, dynamic>> inheritedDutyRoles,
    String? effectiveDate,
    String? expirationDate,
  }) async {
    try {
      await _client.post(
        ApiEndpoints.securityDutyRoles,
        body: {
          'enterprise_id': enterpriseId,
          'duty_role_name': name,
          'duty_role_code': code,
          'category_code': categoryCode,
          'status': status,
          'description': description,
          'effective_date': effectiveDate,
          'expiration_date': expirationDate,
          'requires_manager_approval': requiresManagerApproval,
          'active_flag': activeFlag,
          'actor': actor,
          'function_roles': functionRoles,
          'inherited_duty_roles': inheritedDutyRoles,
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create duty role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateDutyRole({
    required String dutyRoleGuid,
    required int enterpriseId,
    required String name,
    required String code,
    required String categoryCode,
    required String status,
    required String description,
    required String requiresManagerApproval,
    required String activeFlag,
    required String actor,
    required List<Map<String, dynamic>> functionRoles,
    required List<Map<String, dynamic>> inheritedDutyRoles,
    String? effectiveDate,
    String? expirationDate,
  }) async {
    try {
      await _client.put(
        ApiEndpoints.securityDutyRoleByGuid(dutyRoleGuid),
        body: {
          'enterprise_id': enterpriseId,
          'duty_role_name': name,
          'duty_role_code': code,
          'category_code': categoryCode,
          'status': status,
          'description': description,
          'effective_date': effectiveDate,
          'expiration_date': expirationDate,
          'requires_manager_approval': requiresManagerApproval,
          'active_flag': activeFlag,
          'actor': actor,
          'function_roles': functionRoles,
          'inherited_duty_roles': inheritedDutyRoles,
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update duty role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteDutyRole({required String dutyRoleGuid, required int enterpriseId, required String actor}) async {
    try {
      await _client.delete(
        ApiEndpoints.securityDutyRoleByGuid(dutyRoleGuid),
        queryParameters: {'enterprise_id': enterpriseId.toString()},
        body: {'actor': actor},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete duty role: ${e.toString()}', originalError: e);
    }
  }
}
