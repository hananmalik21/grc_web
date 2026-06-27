import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_type.dart';
import 'package:grc/features/security_manager/domain/models/security_lookup_value.dart';
import 'package:grc/features/security_manager/domain/repositories/security_lookups_repository.dart';

class SecurityLookupsRepositoryImpl implements SecurityLookupsRepository {
  const SecurityLookupsRepositoryImpl(this._client);

  final ApiClient _client;

  void _ensureSuccess(Map<String, dynamic> response) {
    final success = response['success'] as bool?;
    if (success == false) {
      throw ServerException(response['message'] as String? ?? 'Request failed', statusCode: 400);
    }
  }

  @override
  Future<List<SecurityLookupType>> getLookupTypes({required int enterpriseId}) async {
    try {
      final response = await _client.get(
        ApiEndpoints.securityLookupTypes,
        queryParameters: {'enterprise_id': enterpriseId.toString()},
      );
      _ensureSuccess(response);
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((e) => SecurityLookupType.fromJson(e as Map<String, dynamic>)).where((t) => t.isActive).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch security lookup types: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<SecurityLookupValue>> getLookupValues({required int enterpriseId, required int lookupTypeId}) async {
    try {
      final response = await _client.get(
        ApiEndpoints.securityLookupValues,
        queryParameters: {'enterprise_id': enterpriseId.toString(), 'lookup_type_id': lookupTypeId.toString()},
      );
      _ensureSuccess(response);
      final data = response['data'] as List<dynamic>? ?? [];
      final values =
          data.map((e) => SecurityLookupValue.fromJson(e as Map<String, dynamic>)).where((v) => v.isActive).toList()
            ..sort((a, b) => a.displaySequence.compareTo(b.displaySequence));
      return values;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch security lookup values: ${e.toString()}', originalError: e);
    }
  }
}
