/// Enum for compensation lookup types used in graph analytics
enum CompensationLookupType {
  category('CATEGORY'),
  calculationMethod('COMP_CALC_METHOD');

  final String value;
  const CompensationLookupType(this.value);

  static CompensationLookupType fromString(String value) {
    switch (value.toUpperCase()) {
      case 'CATEGORY':
        return CompensationLookupType.category;
      case 'COMP_CALC_METHOD':
        return CompensationLookupType.calculationMethod;
      default:
        return CompensationLookupType.category;
    }
  }

  @override
  String toString() => value;
}

enum CompensationFrequency {
  monthly('MONTHLY', 12),
  yearly('YEARLY', 1),
  hourly('HOURLY', 2080),
  daily('DAILY', 260),
  weekly('WEEKLY', 52),
  biWeekly('BI_WEEKLY', 26),
  quarterly('QUARTERLY', 4),
  semiAnnually('SEMI_ANNUALLY', 2);

  final String value;
  final double annualMultiplier;
  const CompensationFrequency(this.value, this.annualMultiplier);

  static CompensationFrequency fromValue(String value) {
    final normalized = value.trim().toUpperCase();
    return CompensationFrequency.values.firstWhere(
      (e) => e.value == normalized,
      orElse: () => CompensationFrequency.monthly,
    );
  }

  String get label {
    switch (this) {
      case CompensationFrequency.monthly:
        return 'Monthly';
      case CompensationFrequency.yearly:
        return 'Yearly';
      case CompensationFrequency.hourly:
        return 'Hourly';
      case CompensationFrequency.daily:
        return 'Daily';
      case CompensationFrequency.weekly:
        return 'Weekly';
      case CompensationFrequency.biWeekly:
        return 'Bi-Weekly';
      case CompensationFrequency.quarterly:
        return 'Quarterly';
      case CompensationFrequency.semiAnnually:
        return 'Semi-Annually';
    }
  }
}

enum ComponentStatus {
  active('ACTIVE', 'Active'),
  inactive('INACTIVE', 'Inactive');

  final String apiValue;
  final String label;
  const ComponentStatus(this.apiValue, this.label);

  static ComponentStatus? fromApiValue(String value) {
    return ComponentStatus.values.where((e) => e.apiValue == value.toUpperCase()).firstOrNull;
  }
}

enum SalaryStructureStatus {
  active('ACTIVE', 'Active'),
  inactive('INACTIVE', 'Inactive');

  final String apiValue;
  final String label;
  const SalaryStructureStatus(this.apiValue, this.label);

  static SalaryStructureStatus? fromApiValue(String value) {
    return SalaryStructureStatus.values.where((e) => e.apiValue == value.toUpperCase()).firstOrNull;
  }
}

enum SalaryChangeHistoryStatus {
  all,
  approved,
  pending,
  rejected;

  String get label => switch (this) {
    SalaryChangeHistoryStatus.all => 'All Status',
    SalaryChangeHistoryStatus.approved => 'Approved',
    SalaryChangeHistoryStatus.pending => 'Pending',
    SalaryChangeHistoryStatus.rejected => 'Rejected',
  };
}

enum SalaryChangeHistoryType {
  all,
  annual,
  promotion,
  merit;

  String get label => switch (this) {
    SalaryChangeHistoryType.all => 'All Types',
    SalaryChangeHistoryType.annual => 'Annual',
    SalaryChangeHistoryType.promotion => 'Promotion',
    SalaryChangeHistoryType.merit => 'Merit',
  };
}

enum AdjustmentMethod {
  percentage('PERCENTAGE'),
  amount('AMOUNT'),
  manual('MANUAL');

  final String code;
  const AdjustmentMethod(this.code);

  static AdjustmentMethod? fromCode(String value) {
    switch (value) {
      case 'PERCENTAGE':
      case '% Increase':
        return AdjustmentMethod.percentage;
      case 'AMOUNT':
      case 'INCREASE':
      case 'Fixed Amount':
        return AdjustmentMethod.amount;
      case 'MANUAL':
      case 'NEW_VALUE':
      case 'New Value':
        return AdjustmentMethod.manual;
      default:
        return null;
    }
  }
}
