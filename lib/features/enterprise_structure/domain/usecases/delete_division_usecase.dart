import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/division_repository.dart';

/// Use case for deleting an existing division
class DeleteDivisionUseCase {
  final DivisionRepository repository;

  DeleteDivisionUseCase({required this.repository});

  /// Executes the use case to delete a division
  ///
  /// [divisionId] - The ID of the division to delete.
  /// [hard] - If true, permanently deletes the division. If false, soft deletes it.
  /// Throws [AppException] if the operation fails
  Future<void> call(int divisionId, {bool hard = true}) async {
    try {
      await repository.deleteDivision(divisionId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete division: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

