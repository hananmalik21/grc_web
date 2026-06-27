import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_unit_tree.dart';
import 'package:grc/features/enterprise_structure/domain/models/paginated_org_units_response.dart';

abstract class OrgUnitRepository {
  Future<List<OrgStructureLevel>> getOrgUnitsByLevel(String levelCode);
  Future<List<OrgStructureLevel>> getOrgUnitsByStructureAndLevel(String structureId, String levelCode);
  Future<PaginatedOrgUnitsResponse> getOrgUnitsByStructureAndLevelPaginated(
    String structureId,
    String levelCode, {
    int? enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  });
  Future<List<OrgStructureLevel>> getParentOrgUnits(String structureId, String levelCode);
  Future<OrgStructureLevel> createOrgUnit(String structureId, Map<String, dynamic> data);
  Future<OrgStructureLevel> updateOrgUnit(String structureId, String orgUnitId, Map<String, dynamic> data);
  Future<void> deleteOrgUnit(String structureId, String orgUnitId, {bool hard = true});
  Future<OrgUnitTree> getOrgUnitsTree({int? enterpriseId});
}
