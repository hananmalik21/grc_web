import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/business_unit_repository.dart';

/// Use case for getting business units
class GetBusinessUnitsUseCase {
  final BusinessUnitRepository repository;

  GetBusinessUnitsUseCase({required this.repository});

  /// Executes the use case to get business units
  ///
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Returns a [PaginatedBusinessUnits] with the list of business units and pagination info
  /// Throws [AppException] if the operation fails
  Future<PaginatedBusinessUnits> call({
    String? search,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      return await repository.getBusinessUnits(
        search: search,
        page: page,
        pageSize: pageSize,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get business units: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

