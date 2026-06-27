import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/security_module.dart';
import 'package:grc/features/security_manager/domain/repositories/security_modules_repository.dart';

class SecurityModulesRepositoryImpl implements SecurityModulesRepository {
  const SecurityModulesRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<SecurityModulePage> getSecurityModules({
    required int enterpriseId,
    required int page,
    required int pageSize,
    String activeFlag = 'Y',
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.securityModules,
        queryParameters: {
          'enterprise_id': enterpriseId.toString(),
          'page': page.toString(),
          'page_size': pageSize.toString(),
          'active_flag': activeFlag,
        },
      );

      final data = response['data'] as List<dynamic>? ?? [];
      final modules = data.map((item) => SecurityModule.fromJson(item as Map<String, dynamic>)).toList();

      final pagination = (response['meta'] as Map<String, dynamic>?)?['pagination'] as Map<String, dynamic>?;

      return SecurityModulePage(
        modules: modules,
        page: (pagination?['page'] as num?)?.toInt() ?? page,
        pageSize: (pagination?['page_size'] as num?)?.toInt() ?? pageSize,
        total: (pagination?['total'] as num?)?.toInt() ?? modules.length,
        totalPages: (pagination?['total_pages'] as num?)?.toInt() ?? 1,
        hasNext: (pagination?['has_next'] as bool?) ?? false,
        hasPrevious: (pagination?['has_previous'] as bool?) ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch security modules: ${e.toString()}', originalError: e);
    }
  }
}
