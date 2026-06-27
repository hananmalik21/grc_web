import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/models/structure_level.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/structure_level_repository.dart';

/// Use case for fetching structure levels
/// Contains business logic for getting structure levels
class GetStructureLevelsUseCase {
  final StructureLevelRepository repository;

  GetStructureLevelsUseCase({required this.repository});

  /// Executes the use case to fetch structure levels
  /// 
  /// Returns a list of [StructureLevel] sorted by level
  /// Throws [AppException] if the operation fails
  Future<List<StructureLevel>> call() async {
    try {
      final levels = await repository.getStructureLevels();
      // Sort by level to ensure correct order
      levels.sort((a, b) => a.level.compareTo(b.level));
      return levels;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get structure levels: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

