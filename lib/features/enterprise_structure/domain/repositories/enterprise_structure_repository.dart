import 'package:grc/features/enterprise_structure/domain/models/enterprise_structure.dart';

abstract class EnterpriseStructureRepository {
  Future<EnterpriseStructure> saveEnterpriseStructure(EnterpriseStructure structure);

  Future<EnterpriseStructure> updateEnterpriseStructure(String structureId, EnterpriseStructure structure);
}
