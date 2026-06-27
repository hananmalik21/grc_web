class ForfeitProcessingSummary {
  final DateTime processingDate;
  final String processedBy;
  final int totalEmployeesAffected;
  final double totalDaysForfeited;
  final String auditLogReference;

  const ForfeitProcessingSummary({
    required this.processingDate,
    required this.processedBy,
    required this.totalEmployeesAffected,
    required this.totalDaysForfeited,
    required this.auditLogReference,
  });
}
