import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/domain/repositories/shift_repository.dart';

/// Use case for creating a shift
class CreateShiftUseCase {
  final ShiftRepository repository;

  CreateShiftUseCase({required this.repository});

  /// Executes the use case to create a shift
  ///
  /// [shiftData] - Map containing shift data to create
  ///
  /// Returns a [ShiftOverview] with the created shift
  /// Throws [AppException] if the operation fails
  Future<ShiftOverview> call({required Map<String, dynamic> shiftData}) async {
    try {
      return await repository.createShift(shiftData: shiftData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create shift: ${e.toString()}', originalError: e);
    }
  }
}
