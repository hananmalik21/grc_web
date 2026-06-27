import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/domain/repositories/work_pattern_repository.dart';

/// Use case for deleting a work pattern
class DeleteWorkPatternUseCase {
  final WorkPatternRepository repository;

  const DeleteWorkPatternUseCase({required this.repository});

  Future<void> execute({required int workPatternId, required bool hard}) async {
    try {
      await repository.deleteWorkPattern(workPatternId: workPatternId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete work pattern: ${e.toString()}', originalError: e);
    }
  }
}
