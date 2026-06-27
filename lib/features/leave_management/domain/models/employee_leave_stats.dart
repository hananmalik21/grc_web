class EmployeeLeaveStats {
  const EmployeeLeaveStats({
    required this.total,
    required this.approved,
    required this.pending,
    required this.rejected,
  });

  final int total;
  final int approved;
  final int pending;
  final int rejected;

  String get totalDisplay => total.toString();
  String get approvedDisplay => approved.toString();
  String get pendingDisplay => pending.toString();
  String get rejectedDisplay => rejected.toString();
}
