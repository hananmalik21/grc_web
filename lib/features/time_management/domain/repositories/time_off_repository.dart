import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';

/// Repository interface for time-off request operations
abstract class TimeOffRepository {
  /// Gets paginated list of time-off requests
  ///
  /// [employeeId] - Optional filter by employee ID
  /// [status] - Optional filter by status
  /// [type] - Optional filter by time-off type
  /// [startDate] - Optional start date filter
  /// [endDate] - Optional end date filter
  /// [search] - Optional search query
  /// [page] - Page number for pagination (default: 1)
  /// [pageSize] - Page size for pagination (default: 10)
  ///
  /// Throws [AppException] if the operation fails
  Future<PaginatedTimeOffRequests> getTimeOffRequests({
    int? employeeId,
    RequestStatus? status,
    TimeOffType? type,
    DateTime? startDate,
    DateTime? endDate,
    String? search,
    int page = 1,
    int pageSize = 10,
  });

  /// Gets time-off request by ID
  ///
  /// Throws [AppException] if the operation fails
  Future<TimeOffRequest> getTimeOffRequestById(int requestId);

  /// Creates a new time-off request
  ///
  /// Throws [AppException] if the operation fails
  Future<TimeOffRequest> createTimeOffRequest(Map<String, dynamic> requestData);

  /// Updates an existing time-off request
  ///
  /// Throws [AppException] if the operation fails
  Future<TimeOffRequest> updateTimeOffRequest(
    int requestId,
    Map<String, dynamic> requestData,
  );

  /// Approves a time-off request
  ///
  /// Throws [AppException] if the operation fails
  Future<TimeOffRequest> approveTimeOffRequest(int requestId);

  /// Rejects a time-off request
  ///
  /// Throws [AppException] if the operation fails
  Future<TimeOffRequest> rejectTimeOffRequest(
    int requestId, {
    required String reason,
  });

  /// Cancels a time-off request
  ///
  /// Throws [AppException] if the operation fails
  Future<TimeOffRequest> cancelTimeOffRequest(int requestId);

  /// Deletes a time-off request
  ///
  /// [hard] - If true, permanently deletes. If false, soft deletes.
  /// Throws [AppException] if the operation fails
  Future<void> deleteTimeOffRequest(int requestId, {bool hard = true});
}
