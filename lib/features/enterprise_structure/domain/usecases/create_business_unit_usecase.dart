import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/business_unit.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/business_unit_repository.dart';

/// Use case for creating a new business unit
class CreateBusinessUnitUseCase {
  final BusinessUnitRepository repository;

  CreateBusinessUnitUseCase({required this.repository});

  /// Executes the use case to create a business unit
  ///
  /// Returns the created [BusinessUnitOverview]
  /// Throws [AppException] if the operation fails
  Future<BusinessUnitOverview> call(Map<String, dynamic> businessUnitData) async {
    try {
      return await repository.createBusinessUnit(businessUnitData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create business unit: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

