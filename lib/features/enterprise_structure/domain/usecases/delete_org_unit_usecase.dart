import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

/// Use case for deleting an org unit
class DeleteOrgUnitUseCase {
  final OrgUnitRepository repository;

  DeleteOrgUnitUseCase({required this.repository});

  /// Executes the use case to delete an org unit
  ///
  /// Throws [AppException] if the operation fails
  Future<void> call(String structureId, String orgUnitId, {bool hard = true}) async {
    try {
      return await repository.deleteOrgUnit(structureId, orgUnitId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete org unit $orgUnitId for structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

