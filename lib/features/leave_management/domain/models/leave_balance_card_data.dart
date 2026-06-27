class LeaveBalanceCardData {
  const LeaveBalanceCardData({
    required this.leaveTypeLabel,
    required this.totalDays,
    required this.usedDays,
    required this.remainingDays,
  });

  final String leaveTypeLabel;
  final int totalDays;
  final int usedDays;
  final int remainingDays;
}
