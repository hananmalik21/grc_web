import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/employee_management/data/dto/empl_lookup_dto.dart';
import 'package:grc/features/workforce_structure/data/dto/create_ent_lookup_values_bulk_request_dto.dart';
import 'package:grc/features/workforce_structure/data/dto/ent_lookup_value_dto.dart';

abstract class EntLookupRemoteDataSource {
  Future<EmplLookupTypesResponseDto> getLookupTypes(int enterpriseId);
  Future<EntLookupValuesResponseDto> getLookupValues(
    int enterpriseId,
    String lookupTypeCode, {
    int page = 1,
    int pageSize = 100,
  });
  Future<void> createLookupValuesBulk(CreateEntLookupValuesBulkRequestDto request);
}

class EntLookupRemoteDataSourceImpl implements EntLookupRemoteDataSource {
  EntLookupRemoteDataSourceImpl({required this.apiClient});
  final ApiClient apiClient;

  @override
  Future<EmplLookupTypesResponseDto> getLookupTypes(int enterpriseId) async {
    final response = await apiClient.get(
      ApiEndpoints.entLookupTypes,
      queryParameters: {'enterprise_id': enterpriseId.toString()},
    );
    return EmplLookupTypesResponseDto.fromJson(response);
  }

  @override
  Future<EntLookupValuesResponseDto> getLookupValues(
    int enterpriseId,
    String lookupTypeCode, {
    int page = 1,
    int pageSize = 100,
  }) async {
    final response = await apiClient.get(
      ApiEndpoints.entLookupValues,
      queryParameters: {
        'enterprise_id': enterpriseId.toString(),
        'lookup_type': lookupTypeCode,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );
    return EntLookupValuesResponseDto.fromJson(response);
  }

  @override
  Future<void> createLookupValuesBulk(CreateEntLookupValuesBulkRequestDto request) async {
    await apiClient.post(ApiEndpoints.entLookupValuesBulk, body: request.toJson());
  }
}
