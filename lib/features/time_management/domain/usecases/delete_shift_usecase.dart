import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/domain/repositories/shift_repository.dart';

class DeleteShiftUseCase {
  final ShiftRepository repository;

  DeleteShiftUseCase({required this.repository});

  Future<void> call({required int shiftId, required bool hard}) async {
    try {
      await repository.deleteShift(shiftId: shiftId, hard: hard);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to delete shift: ${e.toString()}', originalError: e);
    }
  }
}
