import 'package:grc/core/network/exceptions.dart';

/// Repository interface for structure delete operations
abstract class StructureDeleteRepository {
  /// Deletes an organization structure
  ///
  /// [structureId] - The ID of the structure to delete
  /// [hard] - Whether to perform a hard delete (pass only this OR autoFallback, not both)
  /// [autoFallback] - Whether to use auto fallback strategy (pass only this OR hard, not both)
  ///
  /// Returns a map with deletion result data
  ///
  /// Throws [ConflictException] if structure is referenced by org units (when using hard delete)
  /// Throws [AppException] if the operation fails
  Future<Map<String, dynamic>> deleteStructure({
    required String structureId,
    bool? hard,
    bool? autoFallback,
  });
}

