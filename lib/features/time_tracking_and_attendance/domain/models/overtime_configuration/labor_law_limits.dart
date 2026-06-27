class LaborLawLimit {
  final String? otLaborLimitId;
  final String maxDailyOvertime;
  final String maxAnnualOvertime;
  final String minRestPeriod;
  final String lawReference;
  final String notes;

  LaborLawLimit({
    this.otLaborLimitId,
    this.maxDailyOvertime = '',
    this.maxAnnualOvertime = '',
    this.minRestPeriod = '',
    this.lawReference = '',
    this.notes = '',
  });

  factory LaborLawLimit.fromJson(Map<String, dynamic> json) {
    return LaborLawLimit(
      otLaborLimitId: json['ot_labor_limit_id']?.toString(),
      maxDailyOvertime: json['max_daily_overtime_hours']?.toString() ?? '',
      maxAnnualOvertime: json['max_annual_overtime_hours']?.toString() ?? '',
      minRestPeriod: json['min_rest_period_hours']?.toString() ?? '',
      lawReference: json['law_reference']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
    );
  }

  LaborLawLimit copyWith({
    String? otLaborLimitId,
    String? maxDailyOvertime,
    String? maxAnnualOvertime,
    String? minRestPeriod,
    String? lawReference,
    String? notes,
  }) {
    return LaborLawLimit(
      otLaborLimitId: otLaborLimitId ?? this.otLaborLimitId,
      maxDailyOvertime: maxDailyOvertime ?? this.maxDailyOvertime,
      maxAnnualOvertime: maxAnnualOvertime ?? this.maxAnnualOvertime,
      minRestPeriod: minRestPeriod ?? this.minRestPeriod,
      lawReference: lawReference ?? this.lawReference,
      notes: notes ?? this.notes,
    );
  }
}
