import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/business_unit_repository.dart';

/// Use case for deleting an existing business unit
class DeleteBusinessUnitUseCase {
  final BusinessUnitRepository repository;

  DeleteBusinessUnitUseCase({required this.repository});

  /// Executes the use case to delete a business unit
  ///
  /// [businessUnitId] - The ID of the business unit to delete.
  /// [hard] - If true, permanently deletes the business unit. If false, soft deletes it.
  /// Throws [AppException] if the operation fails
  Future<void> call(int businessUnitId, {bool hard = true}) async {
    try {
      await repository.deleteBusinessUnit(businessUnitId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete business unit: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

