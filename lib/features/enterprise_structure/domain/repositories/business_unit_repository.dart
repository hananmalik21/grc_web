import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/business_unit.dart';

/// Repository interface for business unit operations
abstract class BusinessUnitRepository {
  /// Gets paginated list of business units
  ///
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedBusinessUnits> getBusinessUnits({
    String? search,
    int page = 1,
    int pageSize = 10,
  });

  /// Creates a new business unit
  ///
  /// Throws [AppException] if the operation fails
  Future<BusinessUnitOverview> createBusinessUnit(Map<String, dynamic> businessUnitData);

  /// Updates an existing business unit
  ///
  /// Throws [AppException] if the operation fails
  Future<BusinessUnitOverview> updateBusinessUnit(int businessUnitId, Map<String, dynamic> businessUnitData);

  /// Deletes a business unit
  ///
  /// [hard] - If true, permanently deletes the business unit. If false, soft deletes it.
  /// Throws [AppException] if the operation fails
  Future<void> deleteBusinessUnit(int businessUnitId, {bool hard = true});
}

