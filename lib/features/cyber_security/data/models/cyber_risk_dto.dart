class PeopleRiskDto {
  final String id;
  final String email;
  final String fullName;
  final String department;
  final String jobTitle;
  final int riskScore;
  final String riskTier;
  final int anomalousEventsCount;
  final String aiRiskRationale;
  final DateTime? lastEvaluatedAt;

  const PeopleRiskDto({
    required this.id,
    required this.email,
    required this.fullName,
    required this.department,
    required this.jobTitle,
    required this.riskScore,
    required this.riskTier,
    required this.anomalousEventsCount,
    required this.aiRiskRationale,
    this.lastEvaluatedAt,
  });

  factory PeopleRiskDto.fromJson(Map<String, dynamic> json) => PeopleRiskDto(
    id: _string(json['id']),
    email: _string(json['email']),
    fullName: _string(json['fullName'] ?? json['full_name']),
    department: _string(json['department'], fallback: 'Unassigned'),
    jobTitle: _string(json['jobTitle'] ?? json['job_title']),
    riskScore: _int(json['riskScore'] ?? json['risk_score']),
    riskTier: _string(json['riskTier'] ?? json['risk_tier'], fallback: 'LOW'),
    anomalousEventsCount: _int(
      json['anomalousEventsCount'] ?? json['anomalous_events_count'],
    ),
    aiRiskRationale: _string(
      json['aiRiskRationale'] ?? json['ai_risk_rationale'],
    ),
    lastEvaluatedAt: _date(
      json['lastEvaluatedAt'] ?? json['last_evaluated_at'],
    ),
  );
}

class PeopleEvaluationResultDto {
  final int evaluated;
  final int threatsCreated;

  const PeopleEvaluationResultDto({
    required this.evaluated,
    required this.threatsCreated,
  });

  factory PeopleEvaluationResultDto.fromJson(Map<String, dynamic> json) =>
      PeopleEvaluationResultDto(
        evaluated: _int(json['evaluated']),
        threatsCreated: _int(json['threatsCreated'] ?? json['threats_created']),
      );
}

class PeopleHeatmapDepartmentDto {
  final String department;
  final int totalPeople;
  final double avgRiskScore;
  final Map<String, int> tierCounts;

  const PeopleHeatmapDepartmentDto({
    required this.department,
    required this.totalPeople,
    required this.avgRiskScore,
    required this.tierCounts,
  });

  factory PeopleHeatmapDepartmentDto.fromJson(Map<String, dynamic> json) =>
      PeopleHeatmapDepartmentDto(
        department: _string(json['department'], fallback: 'Unassigned'),
        totalPeople: _int(json['totalPeople'] ?? json['total_people']),
        avgRiskScore: _double(json['avgRiskScore'] ?? json['avg_risk_score']),
        tierCounts: (json['tierCounts'] ?? json['tier_counts']) is Map
            ? Map<String, dynamic>.from(
                (json['tierCounts'] ?? json['tier_counts']) as Map,
              ).map((key, value) => MapEntry(key, _int(value)))
            : const {},
      );
}

String _string(dynamic value, {String fallback = ''}) =>
    value?.toString() ?? fallback;
int _int(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
double _double(dynamic value) =>
    value is num ? value.toDouble() : double.tryParse('$value') ?? 0;
DateTime? _date(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
