import 'package:grc/features/workforce_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/workforce_structure/domain/repositories/org_structure_repository.dart';

class GetOrgStructuresByEnterpriseIdUseCase {
  final OrgStructureRepository repository;

  const GetOrgStructuresByEnterpriseIdUseCase({required this.repository});

  Future<List<OrgStructure>> call(int enterpriseId) async {
    return await repository.getOrgStructuresByEnterpriseId(enterpriseId);
  }
}
