import 'package:grc/core/enums/position_status.dart';
import 'package:grc/features/time_management/domain/models/pagination_info.dart';

class WorkPatternDay {
  final int dayOfWeek;
  final String dayType;

  const WorkPatternDay({required this.dayOfWeek, required this.dayType});

  factory WorkPatternDay.fromJson(Map<String, dynamic> json) {
    return WorkPatternDay(dayOfWeek: json['day_of_week'] as int, dayType: json['day_type'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'day_of_week': dayOfWeek, 'day_type': dayType};
  }
}

class WorkPattern {
  final int workPatternId;
  final int tenantId;
  final String patternCode;
  final String patternNameEn;
  final String patternNameAr;
  final String patternType;
  final int totalHoursPerWeek;
  final PositionStatus status;
  final DateTime creationDate;
  final String createdBy;
  final DateTime lastUpdateDate;
  final String lastUpdatedBy;
  final List<WorkPatternDay> days;

  const WorkPattern({
    required this.workPatternId,
    required this.tenantId,
    required this.patternCode,
    required this.patternNameEn,
    required this.patternNameAr,
    required this.patternType,
    required this.totalHoursPerWeek,
    required this.status,
    required this.creationDate,
    required this.createdBy,
    required this.lastUpdateDate,
    required this.lastUpdatedBy,
    required this.days,
  });

  factory WorkPattern.fromJson(Map<String, dynamic> json) {
    final statusStr = json['status'] as String? ?? 'INACTIVE';
    final status = statusStr == 'ACTIVE' ? PositionStatus.active : PositionStatus.inactive;

    final daysJson = json['days'] as List<dynamic>? ?? [];
    final days = daysJson.map((day) => WorkPatternDay.fromJson(day as Map<String, dynamic>)).toList();

    return WorkPattern(
      workPatternId: json['work_pattern_id'] as int,
      tenantId: json['tenant_id'] as int,
      patternCode: json['pattern_code'] == 'null' ? '' : json['pattern_code'] as String? ?? '',
      patternNameEn: json['pattern_name_en'] == 'null' ? '' : json['pattern_name_en'] as String? ?? '',
      patternNameAr: json['pattern_name_ar'] == 'null' ? '' : json['pattern_name_ar'] as String? ?? '',
      patternType: json['pattern_type'] as String,
      totalHoursPerWeek: json['total_hours_per_week'] as int,
      status: status,
      creationDate: DateTime.parse(json['creation_date'] as String),
      createdBy: json['created_by'] as String,
      lastUpdateDate: DateTime.parse(json['last_update_date'] as String),
      lastUpdatedBy: json['last_updated_by'] as String,
      days: days,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'work_pattern_id': workPatternId,
      'tenant_id': tenantId,
      'pattern_code': patternCode,
      'pattern_name_en': patternNameEn,
      'pattern_name_ar': patternNameAr,
      'pattern_type': patternType,
      'total_hours_per_week': totalHoursPerWeek,
      'status': status == PositionStatus.active ? 'ACTIVE' : 'INACTIVE',
      'creation_date': creationDate.toIso8601String(),
      'created_by': createdBy,
      'last_update_date': lastUpdateDate.toIso8601String(),
      'last_updated_by': lastUpdatedBy,
      'days': days.map((day) => day.toJson()).toList(),
    };
  }

  int get workingDays => days.where((day) => day.dayType == 'WORK').length;
  int get restDays => days.where((day) => day.dayType == 'REST').length;
  int get offDays => days.where((day) => day.dayType == 'OFF').length;
}

class PaginatedWorkPatterns {
  final List<WorkPattern> workPatterns;
  final PaginationInfo pagination;

  const PaginatedWorkPatterns({required this.workPatterns, required this.pagination});
}
