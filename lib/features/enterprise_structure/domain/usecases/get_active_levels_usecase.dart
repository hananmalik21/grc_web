import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/active_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/org_structure_level_repository.dart';

class GetActiveLevelsUseCase {
  final OrgStructureLevelRepository repository;

  GetActiveLevelsUseCase({required this.repository});

  Future<List<ActiveStructureLevel>> call({int? enterpriseId}) async {
    try {
      return await repository.getActiveLevels(enterpriseId: enterpriseId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to get active levels: ${e.toString()}', originalError: e);
    }
  }
}
