class TeamLeaveRiskEmployee {
  final String id;
  final String employeeId;
  final String name;
  final String nameArabic;
  final String department;
  final String leaveType;
  final double totalBalance;
  final double atRiskDays;
  final double carryForwardLimit;
  final DateTime expiryDate;
  final RiskLevel riskLevel;

  TeamLeaveRiskEmployee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.nameArabic,
    required this.department,
    required this.leaveType,
    required this.totalBalance,
    required this.atRiskDays,
    required this.carryForwardLimit,
    required this.expiryDate,
    required this.riskLevel,
  });

  int get daysUntilExpiry {
    final now = DateTime.now();
    return expiryDate.difference(now).inDays;
  }
}

enum RiskLevel {
  low,
  medium,
  high;

  String get displayName {
    switch (this) {
      case RiskLevel.low:
        return 'Low';
      case RiskLevel.medium:
        return 'Medium';
      case RiskLevel.high:
        return 'High';
    }
  }
}

class TeamLeaveRiskStats {
  final int teamMembers;
  final int employeesAtRisk;
  final double totalAtRiskDays;
  final double avgAtRiskPerEmployee;

  const TeamLeaveRiskStats({
    required this.teamMembers,
    required this.employeesAtRisk,
    required this.totalAtRiskDays,
    required this.avgAtRiskPerEmployee,
  });
}
