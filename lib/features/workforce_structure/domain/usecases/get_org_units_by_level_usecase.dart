import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_unit_repository.dart';

class GetOrgUnitsByLevelUseCase {
  final OrgUnitRepository repository;

  const GetOrgUnitsByLevelUseCase({required this.repository});

  Future<OrgUnitsResponse> call({
    required String structureId,
    required String levelCode,
    String? parentOrgUnitId,
    String? search,
    int? tenantId,
    int page = 1,
    int pageSize = 100,
  }) async {
    return await repository.getOrgUnitsByLevel(
      structureId: structureId,
      levelCode: levelCode,
      parentOrgUnitId: parentOrgUnitId,
      search: search,
      tenantId: tenantId,
      page: page,
      pageSize: pageSize,
    );
  }
}
