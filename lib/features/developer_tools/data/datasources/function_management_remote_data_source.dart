import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/developer_tools/data/models/action_item.dart';
import 'package:grc/features/developer_tools/data/models/module_item.dart';
import 'package:grc/features/developer_tools/data/models/security_function_model.dart';
import 'package:grc/features/developer_tools/data/models/submodule_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginatedResult<T> {
  const PaginatedResult({
    required this.items,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<T> items;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final bool hasNext;
  final bool hasPrevious;
}

abstract class FunctionManagementRemoteDataSource {
  Future<PaginatedResult<ModuleItem>> getModules({int page = 1, int pageSize = 10});

  Future<PaginatedResult<SubmoduleItem>> getSubmodules({required String moduleGuid, int page = 1, int pageSize = 10});

  Future<PaginatedResult<ActionItem>> getActions({required String subModuleGuid, int page = 1, int pageSize = 10});

  Future<PaginatedResult<SecurityFunctionModel>> getFunctions({String? search, int page = 1, int pageSize = 10});

  Future<void> createFunction({required Map<String, dynamic> body});
}

class FunctionManagementRemoteDataSourceImpl implements FunctionManagementRemoteDataSource {
  const FunctionManagementRemoteDataSourceImpl(this._client);

  final ApiClient _client;

  @override
  Future<PaginatedResult<ModuleItem>> getModules({int page = 1, int pageSize = 10}) async {
    try {
      final response = await _client.get(
        ApiEndpoints.securityModules,
        queryParameters: {'page': page.toString(), 'page_size': pageSize.toString(), 'active_flag': 'Y'},
      );

      final data = response['data'] as List<dynamic>? ?? [];
      final items = data.whereType<Map<String, dynamic>>().map(ModuleItem.fromJson).toList();

      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final pagination = meta['pagination'] as Map<String, dynamic>? ?? {};

      return PaginatedResult(
        items: items,
        currentPage: (pagination['page'] as num?)?.toInt() ?? page,
        totalPages: (pagination['total_pages'] as num?)?.toInt() ?? 1,
        totalItems: (pagination['total'] as num?)?.toInt() ?? items.length,
        pageSize: (pagination['page_size'] as num?)?.toInt() ?? pageSize,
        hasNext: pagination['has_next'] as bool? ?? false,
        hasPrevious: pagination['has_previous'] as bool? ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch modules: $e', originalError: e);
    }
  }

  @override
  Future<PaginatedResult<SubmoduleItem>> getSubmodules({
    required String moduleGuid,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.securityModuleSubmodules(moduleGuid),
        queryParameters: {'page': page.toString(), 'page_size': pageSize.toString()},
      );

      final data = response['data'] as List<dynamic>? ?? [];
      final items = data.whereType<Map<String, dynamic>>().map(SubmoduleItem.fromJson).toList();

      final pagination = response['pagination'] as Map<String, dynamic>? ?? {};

      return PaginatedResult(
        items: items,
        currentPage: (pagination['page'] as num?)?.toInt() ?? page,
        totalPages: (pagination['total_pages'] as num?)?.toInt() ?? 1,
        totalItems: (pagination['total'] as num?)?.toInt() ?? items.length,
        pageSize: (pagination['page_size'] as num?)?.toInt() ?? pageSize,
        hasNext: pagination['has_next'] as bool? ?? false,
        hasPrevious: pagination['has_previous'] as bool? ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch submodules: $e', originalError: e);
    }
  }

  @override
  Future<PaginatedResult<ActionItem>> getActions({
    required String subModuleGuid,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _client.get(
        ApiEndpoints.securitySubmoduleActions(subModuleGuid),
        queryParameters: {'page': page.toString(), 'page_size': pageSize.toString()},
      );

      final data = response['data'] as List<dynamic>? ?? [];
      final items = data.whereType<Map<String, dynamic>>().map(ActionItem.fromJson).toList();

      final meta = response['meta'] as Map<String, dynamic>? ?? {};
      final pagination = meta['pagination'] as Map<String, dynamic>? ?? {};

      return PaginatedResult(
        items: items,
        currentPage: (pagination['page'] as num?)?.toInt() ?? page,
        totalPages: (pagination['total_pages'] as num?)?.toInt() ?? 1,
        totalItems: (pagination['total'] as num?)?.toInt() ?? items.length,
        pageSize: (pagination['page_size'] as num?)?.toInt() ?? pageSize,
        hasNext: pagination['has_next'] as bool? ?? false,
        hasPrevious: pagination['has_previous'] as bool? ?? false,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch actions: $e', originalError: e);
    }
  }

  @override
  Future<PaginatedResult<SecurityFunctionModel>> getFunctions({String? search, int page = 1, int pageSize = 10}) async {
    try {
      final queryParams = {
        'page': page.toString(),
        'page_size': pageSize.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await _client.get(ApiEndpoints.securityFunctions, queryParameters: queryParams);

      final data = response['data'] as List<dynamic>? ?? [];
      final items = data.whereType<Map<String, dynamic>>().map(SecurityFunctionModel.fromJson).toList();

      final pagination = (response['pagination'] as Map<String, dynamic>?) ?? {};

      final total = (pagination['total'] as num?)?.toInt() ?? items.length;
      final resolvedTotalPages =
          (pagination['total_pages'] as num?)?.toInt() ?? (items.isEmpty ? 1 : (total / pageSize).ceil());

      return PaginatedResult(
        items: items,
        currentPage: (pagination['page'] as num?)?.toInt() ?? page,
        totalPages: resolvedTotalPages,
        totalItems: total,
        pageSize: (pagination['page_size'] as num?)?.toInt() ?? pageSize,
        hasNext: pagination['has_next'] as bool? ?? (page < resolvedTotalPages),
        hasPrevious: pagination['has_previous'] as bool? ?? (page > 1),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch functions: $e', originalError: e);
    }
  }

  @override
  Future<void> createFunction({required Map<String, dynamic> body}) async {
    try {
      await _client.post(ApiEndpoints.securityFunctions, body: body);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create function: $e', originalError: e);
    }
  }
}

final _functionManagementApiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ApiConfig.baseUrl);
});

final functionManagementDataSourceProvider = Provider<FunctionManagementRemoteDataSource>((ref) {
  return FunctionManagementRemoteDataSourceImpl(ref.watch(_functionManagementApiClientProvider));
});
