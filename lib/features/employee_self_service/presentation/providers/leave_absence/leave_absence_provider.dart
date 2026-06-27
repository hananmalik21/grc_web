import 'package:grc/features/employee_self_service/presentation/providers/leave_absence/leave_absence_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveAbsenceNotifier extends StateNotifier<LeaveAbsenceState> {
  LeaveAbsenceNotifier() : super(_initial());

  static LeaveAbsenceState _initial() {
    return LeaveAbsenceState(
      headerTitle: 'Leave Requests',
      headerSubtitle: 'Apply for leave and track your requests',
      balances: const [
        LeaveBalanceOverview(label: 'Annual', remainingDays: 22, totalDays: 30),
        LeaveBalanceOverview(label: 'Sick', remainingDays: 13, totalDays: 15),
        LeaveBalanceOverview(label: 'Casual', remainingDays: 4, totalDays: 7),
        LeaveBalanceOverview(label: 'Compassionate', remainingDays: 5, totalDays: 5),
        LeaveBalanceOverview(label: 'Maternity', remainingDays: 70, totalDays: 70),
        LeaveBalanceOverview(label: 'Unpaid', remainingDays: 0, totalDays: 0),
      ],
      allRequests: [
        LeaveAbsenceRequestRecord(
          id: 'LR001',
          leaveType: 'Annual Leave',
          status: LeaveAbsenceRequestStatus.approved,
          startDate: DateTime(2026, 2, 15),
          endDate: DateTime(2026, 2, 20),
          durationLabel: '6 days',
          appliedDate: DateTime(2026, 1, 10),
          reason: 'Family vacation',
          approver: 'Sarah Al-Mutairi',
          approverComment: 'Approved. Enjoy your vacation!',
        ),
        LeaveAbsenceRequestRecord(
          id: 'LR002',
          leaveType: 'Sick Leave',
          status: LeaveAbsenceRequestStatus.pending,
          startDate: DateTime(2026, 3, 10),
          endDate: DateTime(2026, 3, 11),
          durationLabel: '2 days',
          appliedDate: DateTime(2026, 1, 15),
          reason: 'Medical appointment',
          approver: 'Awaiting assignment',
        ),
        LeaveAbsenceRequestRecord(
          id: 'LR003',
          leaveType: 'Casual Leave',
          status: LeaveAbsenceRequestStatus.approved,
          startDate: DateTime(2025, 12, 20),
          endDate: DateTime(2025, 12, 20),
          durationLabel: '1 day',
          appliedDate: DateTime(2025, 12, 15),
          reason: 'Personal errands',
          approver: 'Sarah Al-Mutairi',
        ),
        LeaveAbsenceRequestRecord(
          id: 'LR004',
          leaveType: 'Annual Leave',
          status: LeaveAbsenceRequestStatus.rejected,
          startDate: DateTime(2025, 11, 5),
          endDate: DateTime(2025, 11, 8),
          durationLabel: '4 days',
          appliedDate: DateTime(2025, 10, 28),
          reason: 'Weekend trip',
          approver: 'Sarah Al-Mutairi',
          approverComment: 'Peak business period - cannot approve at this time.',
        ),
      ],
      searchQuery: '',
      selectedStatus: LeaveAbsenceRequestStatus.all,
      currentPage: 1,
      pageSize: 10,
    );
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value, currentPage: 1);
  }

  void setSelectedStatus(LeaveAbsenceRequestStatus status) {
    state = state.copyWith(selectedStatus: status, currentPage: 1);
  }

  void goToPage(int page) {
    state = state.copyWith(currentPage: page.clamp(1, state.totalPages));
  }

  void nextPage() => goToPage(state.currentPage + 1);

  void previousPage() => goToPage(state.currentPage - 1);
}

final leaveAbsenceProvider = StateNotifierProvider<LeaveAbsenceNotifier, LeaveAbsenceState>((ref) {
  return LeaveAbsenceNotifier();
});
