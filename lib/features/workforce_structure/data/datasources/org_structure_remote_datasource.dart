import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/features/workforce_structure/data/dtos/org_structure_dto.dart';
import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';

abstract class OrgStructureRemoteDataSource {
  Future<OrgStructure> getActiveOrgStructureLevels({int? tenantId});
  Future<List<OrgStructure>> getOrgStructuresByEnterpriseId(int enterpriseId, {int? tenantId});
}

class OrgStructureRemoteDataSourceImpl implements OrgStructureRemoteDataSource {
  final ApiClient apiClient;

  const OrgStructureRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrgStructure> getActiveOrgStructureLevels({int? tenantId}) async {
    final queryParams = <String, String>{};
    if (tenantId != null) {
      queryParams['enterprise_id'] = tenantId.toString();
    }

    final response = await apiClient.get(ApiEndpoints.orgStructureLevels, queryParameters: queryParams);

    return OrgStructureDto.fromJson(response['data'] as Map<String, dynamic>).toDomain();
  }

  @override
  Future<List<OrgStructure>> getOrgStructuresByEnterpriseId(int enterpriseId, {int? tenantId}) async {
    final queryParams = <String, String>{'enterprise_id': enterpriseId.toString()};

    final response = await apiClient.get(ApiEndpoints.hrOrgStructures, queryParameters: queryParams);

    final dataList = response['data'] as List<dynamic>? ?? [];
    return dataList.map((item) => OrgStructureDto.fromJson(item as Map<String, dynamic>).toDomain()).toList();
  }
}
