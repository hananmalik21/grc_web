import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/division.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/division_repository.dart';

/// Use case for updating an existing division
class UpdateDivisionUseCase {
  final DivisionRepository repository;

  UpdateDivisionUseCase({required this.repository});

  /// Executes the use case to update a division
  ///
  /// Returns the updated [DivisionOverview]
  /// Throws [AppException] if the operation fails
  Future<DivisionOverview> call(int divisionId, Map<String, dynamic> divisionData) async {
    try {
      return await repository.updateDivision(divisionId, divisionData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to update division: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

