class SeveritySummaryDto {
  final int critical;
  final int high;
  final int medium;
  final int low;
  final int totalOpen;

  const SeveritySummaryDto({
    this.critical = 0,
    this.high = 0,
    this.medium = 0,
    this.low = 0,
    this.totalOpen = 0,
  });

  factory SeveritySummaryDto.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const SeveritySummaryDto();
    return SeveritySummaryDto(
      critical: (json['critical'] as num?)?.toInt() ?? 0,
      high: (json['high'] as num?)?.toInt() ?? 0,
      medium: (json['medium'] as num?)?.toInt() ?? 0,
      low: (json['low'] as num?)?.toInt() ?? 0,
      totalOpen: (json['totalOpen'] as num?)?.toInt() ?? (json['total_open'] as num?)?.toInt() ?? 0,
    );
  }
}

class AtRiskPersonDto {
  final String email;
  final String? fullName;
  final int riskScore;
  final String riskTier;

  const AtRiskPersonDto({
    required this.email,
    this.fullName,
    required this.riskScore,
    required this.riskTier,
  });

  factory AtRiskPersonDto.fromJson(Map<String, dynamic> json) {
    return AtRiskPersonDto(
      email: json['email']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? json['full_name']?.toString(),
      riskScore: (json['riskScore'] as num?)?.toInt() ?? (json['risk_score'] as num?)?.toInt() ?? 0,
      riskTier: json['riskTier']?.toString() ?? json['risk_tier']?.toString() ?? 'LOW',
    );
  }
}

class PeopleRiskSummaryDto {
  final int highRiskCount;
  final int criticalRiskCount;
  final List<AtRiskPersonDto> topAtRisk;

  const PeopleRiskSummaryDto({
    this.highRiskCount = 0,
    this.criticalRiskCount = 0,
    this.topAtRisk = const [],
  });

  factory PeopleRiskSummaryDto.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const PeopleRiskSummaryDto();
    return PeopleRiskSummaryDto(
      highRiskCount: (json['highRiskCount'] as num?)?.toInt() ?? (json['high_risk_count'] as num?)?.toInt() ?? 0,
      criticalRiskCount: (json['criticalRiskCount'] as num?)?.toInt() ?? (json['critical_risk_count'] as num?)?.toInt() ?? 0,
      topAtRisk: (json['topAtRisk'] as List<dynamic>?)
              ?.map((e) => AtRiskPersonDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class CloudConnectorDto {
  final String provider;
  final String name;
  final String status;
  final String? lastSyncAt;

  const CloudConnectorDto({
    required this.provider,
    required this.name,
    required this.status,
    this.lastSyncAt,
  });

  factory CloudConnectorDto.fromJson(Map<String, dynamic> json) {
    return CloudConnectorDto(
      provider: json['provider']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      lastSyncAt: json['lastSyncAt']?.toString() ?? json['last_sync_at']?.toString(),
    );
  }
}

class DetectedThreatDto {
  final String id;
  final String title;
  final String threatType;
  final String severity;
  final String status;
  final String? associatedActor;
  final String? associatedIp;
  final String? occurredAt;

  const DetectedThreatDto({
    required this.id,
    required this.title,
    required this.threatType,
    required this.severity,
    required this.status,
    this.associatedActor,
    this.associatedIp,
    this.occurredAt,
  });

  factory DetectedThreatDto.fromJson(Map<String, dynamic> json) {
    return DetectedThreatDto(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      threatType: json['threatType']?.toString() ?? json['threat_type']?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'LOW',
      status: json['status']?.toString() ?? 'OPEN',
      associatedActor: json['associatedActor']?.toString() ?? json['associated_actor']?.toString(),
      associatedIp: json['associatedIp']?.toString() ?? json['associated_ip']?.toString(),
      occurredAt: json['occurredAt']?.toString() ?? json['occurred_at']?.toString(),
    );
  }
}

class CyberDashboardOverviewDto {
  final double complianceScore;
  final SeveritySummaryDto threatsSummary;
  final SeveritySummaryDto risksSummary;
  final PeopleRiskSummaryDto peopleRiskSummary;
  final List<CloudConnectorDto> cloudCoverage;
  final List<DetectedThreatDto> recentThreats;

  const CyberDashboardOverviewDto({
    this.complianceScore = 0.0,
    this.threatsSummary = const SeveritySummaryDto(),
    this.risksSummary = const SeveritySummaryDto(),
    this.peopleRiskSummary = const PeopleRiskSummaryDto(),
    this.cloudCoverage = const [],
    this.recentThreats = const [],
  });

  factory CyberDashboardOverviewDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] is Map<String, dynamic>) ? json['data'] as Map<String, dynamic> : json;

    return CyberDashboardOverviewDto(
      complianceScore: (data['complianceScore'] as num?)?.toDouble() ?? 0.0,
      threatsSummary: SeveritySummaryDto.fromJson(data['threatsSummary'] as Map<String, dynamic>?),
      risksSummary: SeveritySummaryDto.fromJson(data['risksSummary'] as Map<String, dynamic>?),
      peopleRiskSummary: PeopleRiskSummaryDto.fromJson(data['peopleRiskSummary'] as Map<String, dynamic>?),
      cloudCoverage: (data['cloudCoverage'] as List<dynamic>?)
              ?.map((e) => CloudConnectorDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      recentThreats: (data['recentThreats'] as List<dynamic>?)
              ?.map((e) => DetectedThreatDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
