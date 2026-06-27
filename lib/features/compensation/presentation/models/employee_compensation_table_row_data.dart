class EmployeeCompensationTableRowData {
  final String employeeName;
  final String employeeId;
  final String employeeGuid;
  final String planGuid;
  final String department;
  final String region;
  final String position;
  final String compensationPlan;
  final String salaryStructure;
  final String grade;
  final double baseSalary;
  final double allowances;
  final double benefits;
  final double apiTotalCompensation;
  final String status;

  const EmployeeCompensationTableRowData({
    required this.employeeName,
    required this.employeeId,
    required this.employeeGuid,
    required this.planGuid,
    required this.department,
    required this.region,
    required this.position,
    required this.compensationPlan,
    required this.salaryStructure,
    required this.grade,
    required this.baseSalary,
    required this.allowances,
    required this.benefits,
    this.apiTotalCompensation = 0,
    required this.status,
  });

  double get totalCompensation => apiTotalCompensation;

  String get baseSalaryLabel => _formatCurrency(baseSalary);
  String get allowancesLabel => _formatCurrency(allowances);
  String get benefitsLabel => _formatCurrency(benefits);
  String get totalCompensationLabel => _formatCurrency(totalCompensation);

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;

    return employeeName.toLowerCase().contains(normalized) ||
        employeeId.toLowerCase().contains(normalized) ||
        position.toLowerCase().contains(normalized);
  }

  static String _formatCurrency(double value) {
    final whole = value.round();
    final digits = whole.toString();
    final buffer = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      final reversedIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reversedIndex > 1 && reversedIndex % 3 == 1) {
        buffer.write(',');
      }
    }

    return '\$${buffer.toString()}';
  }
}
