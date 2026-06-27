import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/dto/org_structure_level_dto.dart';
import 'package:grc/features/enterprise_structure/data/dto/org_unit_tree_dto.dart';
import 'package:grc/features/enterprise_structure/data/dto/paginated_org_units_response_dto.dart';

abstract class OrgUnitRemoteDataSource {
  Future<List<OrgStructureLevelDto>> getOrgUnitsByLevel(String levelCode);
  Future<List<OrgStructureLevelDto>> getOrgUnitsByStructureAndLevel(String structureId, String levelCode);
  Future<PaginatedOrgUnitsResponseDto> getOrgUnitsByStructureAndLevelPaginated(
    String structureId,
    String levelCode, {
    int? enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  });
  Future<List<OrgStructureLevelDto>> getParentOrgUnits(String structureId, String levelCode);
  Future<OrgStructureLevelDto> createOrgUnit(String structureId, Map<String, dynamic> data);
  Future<OrgStructureLevelDto> updateOrgUnit(String structureId, String orgUnitId, Map<String, dynamic> data);
  Future<void> deleteOrgUnit(String structureId, String orgUnitId, {bool hard = true});
  Future<OrgUnitTreeResponseDto> getOrgUnitsTree({int? enterpriseId});
}

class OrgUnitRemoteDataSourceImpl implements OrgUnitRemoteDataSource {
  final ApiClient apiClient;

  OrgUnitRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<OrgStructureLevelDto>> getOrgUnitsByLevel(String levelCode) async {
    try {
      final response = await apiClient.get(ApiEndpoints.hrOrgStructuresUnitsByLevel(levelCode));

      List<dynamic> data;
      if (response.containsKey('data') && response['data'] is List) {
        data = response['data'] as List<dynamic>;
      } else if (response.containsKey('units') && response['units'] is List) {
        data = response['units'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      } else {
        data = [];
      }

      return data.whereType<Map<String, dynamic>>().map((json) => OrgStructureLevelDto.fromJson(json)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch org units for level $levelCode: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<OrgStructureLevelDto>> getOrgUnitsByStructureAndLevel(String structureId, String levelCode) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructuresUnitsByStructureAndLevel(structureId, levelCode),
        queryParameters: {'level': levelCode},
      );

      List<dynamic> data = [];

      if (response.containsKey('data')) {
        final responseData = response['data'];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          if (responseData.containsKey('data') && responseData['data'] is List) {
            data = responseData['data'] as List<dynamic>;
          } else if (responseData.containsKey('units') && responseData['units'] is List) {
            data = responseData['units'] as List<dynamic>;
          }
        }
      } else if (response.containsKey('units') && response['units'] is List) {
        data = response['units'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      }

      return data.whereType<Map<String, dynamic>>().map((json) {
        try {
          return OrgStructureLevelDto.fromJson(json);
        } catch (e) {
          rethrow;
        }
      }).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch org units for structure $structureId and level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<PaginatedOrgUnitsResponseDto> getOrgUnitsByStructureAndLevelPaginated(
    String structureId,
    String levelCode, {
    int? enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final queryParameters = <String, String>{
        'level': levelCode,
        'page': page.toString(),
        'page_size': pageSize.toString(),
      };
      if (enterpriseId != null) {
        queryParameters['enterprise_id'] = enterpriseId.toString();
      }
      if (search != null && search.isNotEmpty) {
        queryParameters['search'] = search;
      }

      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructuresUnitsByStructureAndLevel(structureId, levelCode),
        queryParameters: queryParameters,
      );

      return PaginatedOrgUnitsResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch paginated org units for structure $structureId and level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<List<OrgStructureLevelDto>> getParentOrgUnits(String structureId, String levelCode) async {
    try {
      final response = await apiClient.get(
        ApiEndpoints.hrOrgStructuresParentUnits(structureId, levelCode),
        queryParameters: {'level': levelCode},
      );

      List<dynamic> data = [];

      if (response.containsKey('data')) {
        final responseData = response['data'];
        if (responseData is List) {
          data = responseData;
        } else if (responseData is Map) {
          if (responseData.containsKey('data') && responseData['data'] is List) {
            data = responseData['data'] as List<dynamic>;
          } else if (responseData.containsKey('parents') && responseData['parents'] is List) {
            data = responseData['parents'] as List<dynamic>;
          } else if (responseData.containsKey('units') && responseData['units'] is List) {
            data = responseData['units'] as List<dynamic>;
          }
        }
      } else if (response.containsKey('parents') && response['parents'] is List) {
        data = response['parents'] as List<dynamic>;
      } else if (response.containsKey('units') && response['units'] is List) {
        data = response['units'] as List<dynamic>;
      } else if (response is List) {
        data = response as List<dynamic>;
      }

      return data.whereType<Map<String, dynamic>>().map((json) {
        try {
          return OrgStructureLevelDto.fromJson(json);
        } catch (e) {
          rethrow;
        }
      }).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch parent org units for structure $structureId and level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<OrgStructureLevelDto> createOrgUnit(String structureId, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.post(ApiEndpoints.hrOrgStructuresCreateUnit(structureId), body: data);

      Map<String, dynamic> responseData;
      if (response.containsKey('data')) {
        responseData = response['data'] is Map<String, dynamic> ? response['data'] as Map<String, dynamic> : response;
      } else {
        responseData = response;
      }

      return OrgStructureLevelDto.fromJson(responseData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create org unit for structure $structureId: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<OrgStructureLevelDto> updateOrgUnit(String structureId, String orgUnitId, Map<String, dynamic> data) async {
    try {
      final response = await apiClient.put(ApiEndpoints.hrOrgStructuresUpdateUnit(structureId, orgUnitId), body: data);

      Map<String, dynamic> responseData;
      if (response.containsKey('data')) {
        responseData = response['data'] is Map<String, dynamic> ? response['data'] as Map<String, dynamic> : response;
      } else {
        responseData = response;
      }

      return OrgStructureLevelDto.fromJson(responseData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update org unit $orgUnitId for structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<void> deleteOrgUnit(String structureId, String orgUnitId, {bool hard = true}) async {
    try {
      await apiClient.delete(
        ApiEndpoints.hrOrgStructuresDeleteUnit(structureId, orgUnitId),
        queryParameters: {'hard': hard.toString()},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete org unit $orgUnitId for structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }

  @override
  Future<OrgUnitTreeResponseDto> getOrgUnitsTree({int? enterpriseId}) async {
    try {
      final queryParams = enterpriseId != null ? <String, String>{'enterprise_id': enterpriseId.toString()} : null;
      final response = await apiClient.get(ApiEndpoints.orgUnitsTreeActive, queryParameters: queryParams);

      return OrgUnitTreeResponseDto.fromJson(response);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch org units tree: ${e.toString()}', originalError: e);
    }
  }
}
