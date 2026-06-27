import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/domain/repositories/shift_repository.dart';

/// Use case for getting shifts
class GetShiftsUseCase {
  final ShiftRepository repository;

  GetShiftsUseCase({required this.repository});

  /// Executes the use case to get shifts
  ///
  /// [search] - Optional search query
  /// [isActive] - Optional filter by active status
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Returns a [PaginatedShifts] with the list of shifts and pagination info
  /// Throws [AppException] if the operation fails
  Future<PaginatedShifts> call({
    String? search,
    bool? isActive,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      return await repository.getShifts(
        search: search,
        isActive: isActive,
        page: page,
        pageSize: pageSize,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        'Failed to get shifts: ${e.toString()}',
        originalError: e,
      );
    }
  }
}
