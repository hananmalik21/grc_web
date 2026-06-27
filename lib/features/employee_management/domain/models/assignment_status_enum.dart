enum AssignmentStatus {
  active('ACTIVE'),
  inactive('INACTIVE'),
  probation('PROBATION'),
  ended('ENDED'),
  unknown('');

  const AssignmentStatus(this.raw);
  final String raw;

  static AssignmentStatus fromRaw(String? value) {
    if (value == null || value.trim().isEmpty) return AssignmentStatus.unknown;
    final upper = value.trim().toUpperCase();
    for (final e in AssignmentStatus.values) {
      if (e.raw == upper) return e;
    }
    return AssignmentStatus.unknown;
  }
}
