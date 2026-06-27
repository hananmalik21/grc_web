import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';

abstract class OrgStructureLevelRepository {
  Future<List<ActiveStructureLevel>> getActiveLevels({int? enterpriseId});
}
