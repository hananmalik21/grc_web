import 'package:grc/features/leave_management/presentation/providers/leave_filter_provider.dart';
import 'package:grc/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:grc/features/time_management/domain/models/time_off_request.dart';

mixin LeaveRequestsListLogicMixin {
  Map<LeaveFilter, RequestStatus> buildStatusMap() {
    return {
      LeaveFilter.draft: RequestStatus.draft,
      LeaveFilter.pending: RequestStatus.pending,
      LeaveFilter.approved: RequestStatus.approved,
      LeaveFilter.rejected: RequestStatus.rejected,
    };
  }

  List<TimeOffRequest> getFilteredRequests(PaginatedLeaveRequests paginatedLeaveRequests, LeaveFilter filter) {
    if (filter == LeaveFilter.all) {
      return paginatedLeaveRequests.requests;
    }

    final statusMap = buildStatusMap();
    final targetStatus = statusMap[filter];

    if (targetStatus == null) {
      return paginatedLeaveRequests.requests;
    }

    return paginatedLeaveRequests.requests.where((request) => request.status == targetStatus).toList();
  }

  String formatTotalDays(double days) {
    final dayCount = days.toInt();
    return '$dayCount ${dayCount == 1 ? "day" : "days"}';
  }

  /// Returns the localized status label for a given RequestStatus.
  String getStatusLabel(RequestStatus status) {
    return switch (status) {
      RequestStatus.pending => 'Pending',
      RequestStatus.draft => 'Draft',
      RequestStatus.approved => 'Approved',
      RequestStatus.rejected => 'Rejected',
      RequestStatus.cancelled => 'Cancelled',
    };
  }
}
