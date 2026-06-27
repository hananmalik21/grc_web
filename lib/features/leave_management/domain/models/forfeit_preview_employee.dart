class ForfeitPreviewEmployee {
  final String id;
  final String employeeId;
  final String name;
  final String department;
  final String leaveType;
  final double totalBalance;
  final double carryLimit;
  final double forfeitDays;
  final DateTime expiryDate;

  ForfeitPreviewEmployee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.department,
    required this.leaveType,
    required this.totalBalance,
    required this.carryLimit,
    required this.forfeitDays,
    required this.expiryDate,
  });
}
