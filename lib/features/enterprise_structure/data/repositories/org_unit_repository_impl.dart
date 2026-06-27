import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/data/datasources/org_unit_remote_data_source.dart';
import 'package:grc/features/enterprise_structure/data/dto/org_unit_tree_dto.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:grc/features/enterprise_structure/domain/models/paginated_org_units_response.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

class OrgUnitRepositoryImpl implements OrgUnitRepository {
  final OrgUnitRemoteDataSource remoteDataSource;

  OrgUnitRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<OrgStructureLevel>> getOrgUnitsByLevel(String levelCode) async {
    try {
      final dtos = await remoteDataSource.getOrgUnitsByLevel(levelCode);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<OrgStructureLevel>> getOrgUnitsByStructureAndLevel(String structureId, String levelCode) async {
    try {
      final dtos = await remoteDataSource.getOrgUnitsByStructureAndLevel(structureId, levelCode);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<PaginatedOrgUnitsResponse> getOrgUnitsByStructureAndLevelPaginated(
    String structureId,
    String levelCode, {
    int? enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final dto = await remoteDataSource.getOrgUnitsByStructureAndLevelPaginated(
        structureId,
        levelCode,
        enterpriseId: enterpriseId,
        search: search,
        page: page,
        pageSize: pageSize,
      );
      return PaginatedOrgUnitsResponse(
        units: dto.units.map((unitDto) => unitDto.toDomain()).toList(),
        currentPage: dto.currentPage,
        pageSize: dto.pageSize,
        totalPages: dto.totalPages,
        totalItems: dto.totalItems,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<List<OrgStructureLevel>> getParentOrgUnits(String structureId, String levelCode) async {
    try {
      final dtos = await remoteDataSource.getParentOrgUnits(structureId, levelCode);
      return dtos.map((dto) => dto.toDomain()).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<OrgStructureLevel> createOrgUnit(String structureId, Map<String, dynamic> data) async {
    try {
      final dto = await remoteDataSource.createOrgUnit(structureId, data);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<OrgStructureLevel> updateOrgUnit(String structureId, String orgUnitId, Map<String, dynamic> data) async {
    try {
      final dto = await remoteDataSource.updateOrgUnit(structureId, orgUnitId, data);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteOrgUnit(String structureId, String orgUnitId, {bool hard = true}) async {
    try {
      await remoteDataSource.deleteOrgUnit(structureId, orgUnitId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<OrgUnitTree> getOrgUnitsTree({int? enterpriseId}) async {
    try {
      final dto = await remoteDataSource.getOrgUnitsTree(enterpriseId: enterpriseId);

      OrgUnitTreeNode convertTreeNode(OrgUnitTreeNodeDto nodeDto) {
        return OrgUnitTreeNode(
          orgUnitId: nodeDto.orgUnitId,
          orgUnitCode: nodeDto.orgUnitCode,
          orgUnitNameEn: nodeDto.orgUnitNameEn,
          orgUnitNameAr: nodeDto.orgUnitNameAr,
          levelCode: nodeDto.levelCode,
          parentOrgUnitId: nodeDto.parentOrgUnitId,
          parentName: nodeDto.parentName ?? '-',
          managerName: nodeDto.managerName ?? '-',
          location: nodeDto.location ?? '-',
          lastUpdatedDate: nodeDto.lastUpdatedDate ?? '-',
          isActive: nodeDto.isActive.toUpperCase() == 'Y',
          children: nodeDto.children.map((child) => convertTreeNode(child)).toList(),
        );
      }

      return OrgUnitTree(
        structureId: dto.structureId,
        structureName: dto.structureName,
        tree: dto.tree.map((node) => convertTreeNode(node)).toList(),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Repository error: ${e.toString()}', originalError: e);
    }
  }
}
