import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/division.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/division_repository.dart';

/// Use case for creating a new division
class CreateDivisionUseCase {
  final DivisionRepository repository;

  CreateDivisionUseCase({required this.repository});

  /// Executes the use case to create a division
  ///
  /// Returns the created [DivisionOverview]
  /// Throws [AppException] if the operation fails
  Future<DivisionOverview> call(Map<String, dynamic> divisionData) async {
    try {
      return await repository.createDivision(divisionData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to create division: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

