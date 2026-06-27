enum EmployeeStatus {
  active('ACTIVE'),
  inactive('INACTIVE'),
  terminated('TERMINATED'),
  onLeave('ON_LEAVE'),
  probation('PROBATION'),
  unknown('');

  const EmployeeStatus(this.raw);
  final String raw;

  static EmployeeStatus fromRaw(String? value) {
    if (value == null || value.trim().isEmpty) return EmployeeStatus.unknown;
    final upper = value.trim().toUpperCase();
    for (final e in EmployeeStatus.values) {
      if (e.raw == upper) return e;
    }
    return EmployeeStatus.unknown;
  }
}
