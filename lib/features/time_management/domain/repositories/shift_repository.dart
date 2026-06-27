import 'package:grc/features/time_management/domain/models/shift.dart';

/// Repository interface for shift operations
abstract class ShiftRepository {
  Future<PaginatedShifts> getShifts({String? search, bool? isActive, int page = 1, int pageSize = 10});

  Future<ShiftOverview> createShift({required Map<String, dynamic> shiftData});

  Future<ShiftOverview> updateShift({required int shiftId, required Map<String, dynamic> shiftData});

  Future<void> deleteShift({required int shiftId, required bool hard});
}
