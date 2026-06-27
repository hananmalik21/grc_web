import 'package:grc/features/workforce_structure/data/datasources/org_unit_remote_datasource.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/models/org_unit_hierarchy_item.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_unit_repository.dart';

class OrgUnitRepositoryImpl implements OrgUnitRepository {
  final OrgUnitRemoteDataSource remoteDataSource;

  const OrgUnitRepositoryImpl({required this.remoteDataSource});

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
    return await remoteDataSource.getOrgUnitsByLevel(
      structureId: structureId,
      levelCode: levelCode,
      parentOrgUnitId: parentOrgUnitId,
      search: search,
      tenantId: tenantId,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<List<OrgUnitHierarchyItem>> getOrgUnitHierarchy({
    required int enterpriseId,
    required String orgUnitId,
  }) async {
    return remoteDataSource.getOrgUnitHierarchy(
      enterpriseId: enterpriseId,
      orgUnitId: orgUnitId,
    );
  }
}
