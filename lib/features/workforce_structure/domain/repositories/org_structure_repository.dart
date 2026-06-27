import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';

abstract class OrgStructureRepository {
  Future<OrgStructure> getActiveOrgStructureLevels({int? tenantId});
  Future<List<OrgStructure>> getOrgStructuresByEnterpriseId(int enterpriseId, {int? tenantId});
}
