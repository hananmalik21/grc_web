import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/data_role.dart';
import 'package:grc/features/security_manager/domain/repositories/data_roles_repository.dart';

class DataRolesRepositoryImpl implements DataRolesRepository {
  const DataRolesRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<void> createDataRole({required Map<String, dynamic> body}) async {
    try {
      await _client.post(ApiEndpoints.securityDataRoles, body: body);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create data role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateDataRole({required String dataRoleGuid, required Map<String, dynamic> body}) async {
    try {
      await _client.put(ApiEndpoints.securityDataRoleByGuid(dataRoleGuid), body: body);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update data role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<DataRolePage> getDataRoles({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
    String? dataTypeCode,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.clamp(1, 10).toString(),
      };
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }
      if (dataTypeCode != null && dataTypeCode.isNotEmpty) {
        queryParameters['data_type_code'] = dataTypeCode;
      }

      final response = await _client.get(ApiEndpoints.securityDataRoles, queryParameters: queryParameters);
      final data = response['data'] as List<dynamic>? ?? [];
      final roles = data.map((item) => DataRole.fromJson(item as Map<String, dynamic>)).toList();
      final pagination = (response['meta'] as Map<String, dynamic>?)?['pagination'] as Map<String, dynamic>? ?? {};
      return DataRolePage(
        roles: roles,
        total: (pagination['total'] as num?)?.toInt() ?? roles.length,
        page: (pagination['page'] as num?)?.toInt() ?? page,
        pageSize: (pagination['page_size'] as num?)?.toInt() ?? pageSize,
        totalPages: (pagination['total_pages'] as num?)?.toInt() ?? 1,
        hasNext: pagination['has_next'] as bool? ?? false,
        hasPrevious: pagination['has_previous'] as bool? ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch data roles: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteDataRole({required String dataRoleGuid, required int enterpriseId, required String actor}) async {
    try {
      await _client.delete(
        ApiEndpoints.securityDataRoleByGuid(dataRoleGuid),
        queryParameters: {'enterprise_id': enterpriseId.toString(), 'actor': actor},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete data role: ${e.toString()}', originalError: e);
    }
  }
}
