/// Policy status from ABS policies API.
enum PolicyStatus {
  active('ACTIVE'),
  inactive('INACTIVE'),
  draft('DRAFT');

  const PolicyStatus(this.code);
  final String code;

  static PolicyStatus fromCode(String? code) {
    if (code == null || code.isEmpty) return PolicyStatus.active;
    return PolicyStatus.values.firstWhere((e) => e.code == code.toUpperCase(), orElse: () => PolicyStatus.active);
  }
}

/// Accrual method from ABS policies API.
enum PolicyAccrualMethod {
  monthly('MONTHLY'),
  yearly('YEARLY'),
  none('NONE');

  const PolicyAccrualMethod(this.code);
  final String code;

  static PolicyAccrualMethod fromCode(String? code) {
    if (code == null || code.isEmpty) return PolicyAccrualMethod.none;
    return PolicyAccrualMethod.values.firstWhere(
      (e) => e.code == code.toUpperCase(),
      orElse: () => PolicyAccrualMethod.none,
    );
  }

  String get displayName {
    switch (this) {
      case PolicyAccrualMethod.monthly:
        return 'Monthly';
      case PolicyAccrualMethod.yearly:
        return 'Yearly';
      case PolicyAccrualMethod.none:
        return 'None';
    }
  }
}
