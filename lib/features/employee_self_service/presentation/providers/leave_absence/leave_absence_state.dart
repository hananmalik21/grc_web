import 'package:flutter/material.dart';

enum LeaveAbsenceRequestStatus { all, approved, pending, rejected }

extension LeaveAbsenceRequestStatusX on LeaveAbsenceRequestStatus {
  String get label {
    return switch (this) {
      LeaveAbsenceRequestStatus.all => 'All Status',
      LeaveAbsenceRequestStatus.approved => 'Approved',
      LeaveAbsenceRequestStatus.pending => 'Pending',
      LeaveAbsenceRequestStatus.rejected => 'Rejected',
    };
  }

  IconData get icon {
    return switch (this) {
      LeaveAbsenceRequestStatus.all => Icons.filter_alt_outlined,
      LeaveAbsenceRequestStatus.approved => Icons.check_circle_outline_rounded,
      LeaveAbsenceRequestStatus.pending => Icons.watch_later_outlined,
      LeaveAbsenceRequestStatus.rejected => Icons.cancel_outlined,
    };
  }
}

class LeaveBalanceOverview {
  final String label;
  final int remainingDays;
  final int totalDays;

  const LeaveBalanceOverview({
    required this.label,
    required this.remainingDays,
    required this.totalDays,
  });
}

class LeaveAbsenceRequestRecord {
  final String id;
  final String leaveType;
  final LeaveAbsenceRequestStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final String durationLabel;
  final DateTime appliedDate;
  final String reason;
  final String approver;
  final String? approverComment;

  const LeaveAbsenceRequestRecord({
    required this.id,
    required this.leaveType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.durationLabel,
    required this.appliedDate,
    required this.reason,
    required this.approver,
    this.approverComment,
  });
}

class LeaveAbsenceState {
  final String headerTitle;
  final String headerSubtitle;
  final List<LeaveBalanceOverview> balances;
  final List<LeaveAbsenceRequestRecord> allRequests;
  final String searchQuery;
  final LeaveAbsenceRequestStatus selectedStatus;
  final int currentPage;
  final int pageSize;

  const LeaveAbsenceState({
    required this.headerTitle,
    required this.headerSubtitle,
    required this.balances,
    required this.allRequests,
    required this.searchQuery,
    required this.selectedStatus,
    required this.currentPage,
    required this.pageSize,
  });

  List<LeaveAbsenceRequestRecord> get filteredRequests {
    final query = searchQuery.trim().toLowerCase();

    return allRequests.where((request) {
      final matchesStatus = selectedStatus == LeaveAbsenceRequestStatus.all || request.status == selectedStatus;
      if (!matchesStatus) return false;

      if (query.isEmpty) return true;

      return request.leaveType.toLowerCase().contains(query) ||
          request.reason.toLowerCase().contains(query) ||
          request.id.toLowerCase().contains(query) ||
          request.approver.toLowerCase().contains(query);
    }).toList();
  }

  int get totalItems => filteredRequests.length;

  int get totalPages => totalItems == 0 ? 1 : (totalItems / pageSize).ceil();

  bool get hasPrevious => currentPage > 1;

  bool get hasNext => currentPage < totalPages;

  List<LeaveAbsenceRequestRecord> get paginatedRequests {
    final startIndex = (currentPage - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, filteredRequests.length);
    if (startIndex >= filteredRequests.length) return const [];
    return filteredRequests.sublist(startIndex, endIndex);
  }

  LeaveAbsenceState copyWith({
    String? headerTitle,
    String? headerSubtitle,
    List<LeaveBalanceOverview>? balances,
    List<LeaveAbsenceRequestRecord>? allRequests,
    String? searchQuery,
    LeaveAbsenceRequestStatus? selectedStatus,
    int? currentPage,
    int? pageSize,
  }) {
    return LeaveAbsenceState(
      headerTitle: headerTitle ?? this.headerTitle,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      balances: balances ?? this.balances,
      allRequests: allRequests ?? this.allRequests,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
