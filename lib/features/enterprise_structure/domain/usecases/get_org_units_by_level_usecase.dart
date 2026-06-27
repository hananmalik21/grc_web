import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

/// Use case for getting org units by level code
class GetOrgUnitsByLevelUseCase {
  final OrgUnitRepository repository;

  GetOrgUnitsByLevelUseCase({required this.repository});

  /// Executes the use case to get org units by level
  ///
  /// Returns a list of [OrgStructureLevel]
  /// Throws [AppException] if the operation fails
  Future<List<OrgStructureLevel>> call(String levelCode) async {
    try {
      return await repository.getOrgUnitsByLevel(levelCode);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get org units for level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }

  /// Executes the use case to get org units by structure ID and level
  ///
  /// Returns a list of [OrgStructureLevel]
  /// Throws [AppException] if the operation fails
  Future<List<OrgStructureLevel>> callWithStructureId(String structureId, String levelCode) async {
    try {
      return await repository.getOrgUnitsByStructureAndLevel(structureId, levelCode);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get org units for structure $structureId and level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

