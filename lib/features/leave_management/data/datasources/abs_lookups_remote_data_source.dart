import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/leave_management/data/dto/abs_lookup_values_dto.dart';
import 'package:grc/features/leave_management/data/dto/abs_lookups_dto.dart';

abstract class AbsLookupsRemoteDataSource {
  Future<AbsLookupsResponseDto> getLookups({required int tenantId});
  Future<AbsLookupValuesResponseDto> getLookupValues({required int lookupId, required int tenantId});
}

class AbsLookupsRemoteDataSourceImpl implements AbsLookupsRemoteDataSource {
  final ApiClient apiClient;

  AbsLookupsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AbsLookupsResponseDto> getLookups({required int tenantId}) async {
    try {
      final queryParameters = <String, String>{'tenant_id': tenantId.toString()};
      final response = await apiClient.get(ApiEndpoints.absLookups, queryParameters: queryParameters);
      return AbsLookupsResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch ABS lookups: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<AbsLookupValuesResponseDto> getLookupValues({required int lookupId, required int tenantId}) async {
    try {
      final queryParameters = <String, String>{'tenant_id': tenantId.toString()};
      final response = await apiClient.get(ApiEndpoints.absLookupValues(lookupId), queryParameters: queryParameters);
      return AbsLookupValuesResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch ABS lookup values: ${e.toString()}', originalError: e);
    }
  }
}
