import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/paginated_org_units_response.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/org_unit_repository.dart';

/// Use case for getting paginated org units with search
class GetOrgUnitsPaginatedUseCase {
  final OrgUnitRepository repository;

  GetOrgUnitsPaginatedUseCase({required this.repository});

  /// Executes the use case to get paginated org units
  ///
  /// Returns [PaginatedOrgUnitsResponse]
  /// Throws [AppException] if the operation fails
  Future<PaginatedOrgUnitsResponse> call(
    String structureId,
    String levelCode, {
    int? enterpriseId,
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      return await repository.getOrgUnitsByStructureAndLevelPaginated(
        structureId,
        levelCode,
        enterpriseId: enterpriseId,
        search: search,
        page: page,
        pageSize: pageSize,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to fetch paginated org units for structure $structureId and level $levelCode: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
