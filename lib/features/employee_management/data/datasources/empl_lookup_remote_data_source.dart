import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/employee_management/data/dto/empl_lookup_dto.dart';

abstract class EmplLookupRemoteDataSource {
  Future<EmplLookupTypesResponseDto> getLookupTypes(int enterpriseId);
  Future<EmplLookupValuesResponseDto> getLookupValues(int enterpriseId, String lookupTypeCode);
}

class EmplLookupRemoteDataSourceImpl implements EmplLookupRemoteDataSource {
  EmplLookupRemoteDataSourceImpl({required this.apiClient});
  final ApiClient apiClient;

  @override
  Future<EmplLookupTypesResponseDto> getLookupTypes(int enterpriseId) async {
    final response = await apiClient.get(
      ApiEndpoints.emplLookupTypes,
      queryParameters: {'enterprise_id': enterpriseId.toString()},
    );
    return EmplLookupTypesResponseDto.fromJson(response);
  }

  @override
  Future<EmplLookupValuesResponseDto> getLookupValues(int enterpriseId, String lookupTypeCode) async {
    final response = await apiClient.get(
      ApiEndpoints.emplLookupValues,
      queryParameters: {'enterprise_id': enterpriseId.toString(), 'lookup_type': lookupTypeCode},
    );
    return EmplLookupValuesResponseDto.fromJson(response);
  }
}
