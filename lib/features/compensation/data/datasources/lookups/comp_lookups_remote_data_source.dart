import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/compensation/data/dto/lookups/comp_lookup_graph_count_dto.dart';
import 'package:grc/features/compensation/data/dto/lookups/comp_lookup_type_dto.dart';
import 'package:grc/features/compensation/data/dto/lookups/comp_lookup_value_dto.dart';

abstract class CompLookupsRemoteDataSource {
  Future<List<CompLookupTypeDto>> getLookupTypes();

  Future<List<CompLookupValueDto>> getLookupValues({required int tenantId, required String lookupTypeCode});

  Future<List<CompLookupGraphCountItemDto>> getGraphCounts({required int tenantId, required String lookupTypeCode});
}

class CompLookupsRemoteDataSourceImpl implements CompLookupsRemoteDataSource {
  final ApiClient apiClient;

  CompLookupsRemoteDataSourceImpl({required this.apiClient});

  Map<String, String> _buildHeaders() {
    return {'x-user-id': 'admin'};
  }

  @override
  Future<List<CompLookupTypeDto>> getLookupTypes() async {
    try {
      final response = await apiClient.get(ApiEndpoints.compLookupTypes, headers: _buildHeaders());
      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch lookup types';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>? ?? const [];
      return data.map((e) => CompLookupTypeDto.fromJson(e as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch lookup types: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompLookupValueDto>> getLookupValues({required int tenantId, required String lookupTypeCode}) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.compLookupValues,
        queryParameters: {'tenant_id': tenantId.toString(), 'lookup_type_code': lookupTypeCode},
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch lookup values';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>? ?? const [];
      return data.map((e) => CompLookupValueDto.fromJson(e as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch lookup values: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<CompLookupGraphCountItemDto>> getGraphCounts({
    required int tenantId,
    required String lookupTypeCode,
  }) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.compLookupValuesGraphCounts,
        queryParameters: {'tenant_id': tenantId.toString(), 'lookup_type_code': lookupTypeCode},
        headers: _buildHeaders(),
      );

      final success = response['success'] as bool?;
      if (success == false) {
        final message = response['message'] as String? ?? 'Failed to fetch graph counts';
        throw ServerException(message, statusCode: 400);
      }

      final data = response['data'] as List<dynamic>? ?? const [];
      return data.map((e) => CompLookupGraphCountItemDto.fromJson(e as Map<String, dynamic>)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch graph counts: ${e.toString()}', originalError: e);
    }
  }
}
