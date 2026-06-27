import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/job_role.dart';
import 'package:grc/features/security_manager/domain/repositories/job_roles_repository.dart';

class JobRolesRepositoryImpl implements JobRolesRepository {
  const JobRolesRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<void> createJobRole({required Map<String, dynamic> body}) async {
    try {
      await _client.post(ApiEndpoints.securityJobRoles, body: body);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create job role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteJobRole({required String jobRoleGuid}) async {
    try {
      await _client.delete(ApiEndpoints.securityJobRoleByGuid(jobRoleGuid), body: const {'deleted_by': 'ADMIN'});
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete job role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> updateJobRole({required String jobRoleGuid, required Map<String, dynamic> body}) async {
    try {
      await _client.put(ApiEndpoints.securityJobRoleByGuid(jobRoleGuid), body: body);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update job role: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<JobRolePage> getJobRoles({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String? search,
  }) async {
    try {
      final queryParameters = <String, String>{
        'enterprise_id': enterpriseId.toString(),
        'page': page.toString(),
        'page_size': pageSize.clamp(1, 10).toString(),
      };
      if (search != null && search.isNotEmpty) queryParameters['search'] = search;
      final response = await _client.get(ApiEndpoints.securityJobRoles, queryParameters: queryParameters);

      final data = response['data'] as List<dynamic>? ?? [];
      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final pagination = meta['pagination'] as Map<String, dynamic>? ?? {};

      return JobRolePage(
        roles: data.map((e) => JobRole.fromJson(e as Map<String, dynamic>)).toList(),
        total: (pagination['total'] as num?)?.toInt() ?? 0,
        page: (pagination['page'] as num?)?.toInt() ?? page,
        pageSize: (pagination['page_size'] as num?)?.toInt() ?? pageSize,
        totalPages: (pagination['total_pages'] as num?)?.toInt() ?? 1,
        hasNext: pagination['has_next'] as bool? ?? false,
        hasPrevious: pagination['has_previous'] as bool? ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch job roles: ${e.toString()}', originalError: e);
    }
  }
}
