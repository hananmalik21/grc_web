import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_structure_repository.dart';

class GetActiveOrgStructureLevelsUseCase {
  final OrgStructureRepository repository;

  const GetActiveOrgStructureLevelsUseCase({required this.repository});

  Future<OrgStructure> call({int? tenantId}) async {
    return await repository.getActiveOrgStructureLevels(tenantId: tenantId);
  }
}
