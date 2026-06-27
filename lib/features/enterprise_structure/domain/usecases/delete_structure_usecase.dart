import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/enterprise_structure/domain/repositories/structure_delete_repository.dart';

/// Use case for deleting an organization structure
class DeleteStructureUseCase {
  final StructureDeleteRepository repository;

  DeleteStructureUseCase({required this.repository});

  /// Executes the use case to delete a structure
  ///
  /// [structureId] - The ID of the structure to delete
  /// [hard] - Whether to perform a hard delete (pass only this OR autoFallback, not both)
  /// [autoFallback] - Whether to use auto fallback strategy (pass only this OR hard, not both)
  ///
  /// Returns a map with deletion result data
  ///
  /// Throws [ConflictException] if structure is referenced by org units (when using hard delete)
  /// Throws [AppException] if the operation fails
  Future<Map<String, dynamic>> call({
    required String structureId,
    bool? hard,
    bool? autoFallback,
  }) async {
    try {
      return await repository.deleteStructure(
        structureId: structureId,
        hard: hard,
        autoFallback: autoFallback,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to delete structure $structureId: ${e.toString()}',
        originalError: e,
      );
    }
  }
}

