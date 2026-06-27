import 'package:grc/core/network/api_client.dart';
import 'package:grc/features/workforce_structure/data/dtos/org_unit_dto.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit_hierarchy_item.dart';

abstract class OrgUnitRemoteDataSource {
  Future<OrgUnitsResponse> getOrgUnitsByLevel({
    required String structureId,
    required String levelCode,
    String? parentOrgUnitId,
    String? search,
    int? tenantId,
    int page = 1,
    int pageSize = 100,
  });

  Future<List<OrgUnitHierarchyItem>> getOrgUnitHierarchy({required int enterpriseId, required String orgUnitId});
}

class OrgUnitRemoteDataSourceImpl implements OrgUnitRemoteDataSource {
  final ApiClient apiClient;

  const OrgUnitRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrgUnitsResponse> getOrgUnitsByLevel({
    required String structureId,
    required String levelCode,
    String? parentOrgUnitId,
    String? search,
    int? tenantId,
    int page = 1,
    int pageSize = 100,
  }) async {
    final queryParams = <String, String>{'level': levelCode, 'page': page.toString(), 'page_size': pageSize.toString()};

    if (parentOrgUnitId != null) {
      queryParams['parentId'] = parentOrgUnitId.toString();
    }

    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    if (tenantId != null) {
      queryParams['enterprise_id'] = tenantId.toString();
    }

    final response = await apiClient.get('/api/hr-org-structures/$structureId/org-units', queryParameters: queryParams);

    return OrgUnitsResponseDto.fromJson(response).toDomain();
  }

  @override
  Future<List<OrgUnitHierarchyItem>> getOrgUnitHierarchy({required int enterpriseId, required String orgUnitId}) async {
    final response = await apiClient.get('/api/org-units/$enterpriseId/$orgUnitId/hierarchy');
    final data = response['data'] as List<dynamic>? ?? [];
    return data.map((item) => OrgUnitHierarchyItem.fromJson(item as Map<String, dynamic>)).toList()
      ..sort((a, b) => a.displayLevel.compareTo(b.displayLevel));
  }
}
