import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/active_structure_level_dto.dart';

abstract class OrgStructureLevelRemoteDataSource {
  Future<ActiveStructureResponseDto> getActiveLevels({int? enterpriseId});
}

class OrgStructureLevelRemoteDataSourceImpl implements OrgStructureLevelRemoteDataSource {
  final ApiClient apiClient;

  OrgStructureLevelRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ActiveStructureResponseDto> getActiveLevels({int? enterpriseId}) async {
    try {
      final queryParams = enterpriseId != null ? <String, String>{'enterprise_id': enterpriseId.toString()} : null;
      final response = await apiClient.get(ApiEndpoints.hrOrgStructuresActiveLevels, queryParameters: queryParams);

      Map<String, dynamic> data;
      if (response.containsKey('data') && response['data'] is Map) {
        data = response['data'] as Map<String, dynamic>;
      } else {
        data = response;
      }

      return ActiveStructureResponseDto.fromJson(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch active levels: ${e.toString()}', originalError: e);
    }
  }
}
