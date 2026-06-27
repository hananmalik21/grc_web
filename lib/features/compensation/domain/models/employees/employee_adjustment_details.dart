class EmployeeAdjustmentDetails {
  const EmployeeAdjustmentDetails({
    required this.employeeNumber,
    required this.departmentName,
    required this.currencyCode,
    required this.baseSalary,
    required this.totalAllowances,
  });

  final String employeeNumber;
  final String departmentName;
  final String currencyCode;
  final double baseSalary;
  final double totalAllowances;

  double get totalCompensation => baseSalary + totalAllowances;

  String get formattedBaseSalary => '$currencyCode ${baseSalary.toStringAsFixed(0)}';
  String get formattedAllowances => '$currencyCode ${totalAllowances.toStringAsFixed(0)}';
  String get formattedTotalCompensation => '$currencyCode ${totalCompensation.toStringAsFixed(0)}';

  factory EmployeeAdjustmentDetails.fromApi(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>?) ?? const {};
    final assignment = (data['assignment'] as Map<String, dynamic>?) ?? const {};
    final compensation = (data['compensation'] as Map<String, dynamic>?) ?? const {};
    final allowances = (data['allowances'] as Map<String, dynamic>?) ?? const {};

    final orgList = (assignment['org_structure_list'] as List<dynamic>?) ?? const [];
    final department = orgList
        .whereType<Map<String, dynamic>>()
        .firstWhere(
          (item) => (item['level_code']?.toString() ?? '') == 'DEPARTMENT',
          orElse: () => const {},
        )['org_unit_name_en']
        ?.toString();

    double parseNum(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0;
    }

    final baseSalary = parseNum(compensation['basic_salary_kwd']);
    final totalAllowances =
        parseNum(allowances['housing_kwd']) +
        parseNum(allowances['transport_kwd']) +
        parseNum(allowances['food_kwd']) +
        parseNum(allowances['mobile_kwd']) +
        parseNum(allowances['other_kwd']);

    return EmployeeAdjustmentDetails(
      employeeNumber: assignment['employee_number']?.toString() ?? '',
      departmentName: department?.trim().isNotEmpty == true ? department!.trim() : '',
      currencyCode: assignment['grade'] is Map<String, dynamic>
          ? ((assignment['grade'] as Map<String, dynamic>)['currency_code']?.toString() ?? 'KWD')
          : 'KWD',
      baseSalary: baseSalary,
      totalAllowances: totalAllowances,
    );
  }
}
