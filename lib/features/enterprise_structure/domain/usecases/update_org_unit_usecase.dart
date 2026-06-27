import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

/// Use case for updating an org unit
class UpdateOrgUnitUseCase {
  final OrgUnitRepository repository;

  UpdateOrgUnitUseCase({required this.repository});

  /// Executes the use case to update an org unit
  ///
  /// Returns the updated [OrgStructureLevel]
  /// Throws [AppException] if the operation fails
  Future<OrgStructureLevel> call(String structureId, String orgUnitId, Map<String, dynamic> data) async {
    try {
      return await repository.updateOrgUnit(structureId, orgUnitId, data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update org unit $orgUnitId for structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

