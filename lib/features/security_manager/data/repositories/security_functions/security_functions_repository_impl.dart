import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/security_function.dart';
import 'package:grc/features/security_manager/domain/repositories/security_functions_repository.dart';

class SecurityFunctionsRepositoryImpl implements SecurityFunctionsRepository {
  const SecurityFunctionsRepositoryImpl(this._client);

  final ApiClient _client;

  @override
  Future<SecurityFunctionPage> getSecurityFunctions({required int page, required int pageSize, String? search}) async {
    try {
      final response = await _client.get(
        ApiEndpoints.securityFunctions,
        queryParameters: {
          'page': page.toString(),
          'page_size': pageSize.toString(),
          if (search != null && search.isNotEmpty) 'search': search,
        },
      );

      final data = response['data'] as List<dynamic>? ?? [];
      final functions = data.map((item) => SecurityFunction.fromJson(item as Map<String, dynamic>)).toList();

      final pagination = response['pagination'] as Map<String, dynamic>?;

      return SecurityFunctionPage(
        functions: functions,
        page: (pagination?['page'] as int?) ?? page,
        pageSize: (pagination?['page_size'] as int?) ?? pageSize,
        total: (pagination?['total'] as int?) ?? functions.length,
        totalPages: (pagination?['total_pages'] as int?) ?? 1,
        hasNext: (pagination?['has_next'] as bool?) ?? false,
        hasPrevious: (pagination?['has_previous'] as bool?) ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch security functions: ${e.toString()}', originalError: e);
    }
  }
}
