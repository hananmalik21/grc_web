class ThreatDto {
  final String id;
  final String title;
  final String threatType;
  final String severity;
  final String status;
  final String? associatedActor;
  final String? associatedIp;
  final String? mitreTechniqueId;
  final String? aiAnalysisSummary;
  final DateTime? occurredAt;

  const ThreatDto({
    required this.id,
    required this.title,
    required this.threatType,
    required this.severity,
    required this.status,
    this.associatedActor,
    this.associatedIp,
    this.mitreTechniqueId,
    this.aiAnalysisSummary,
    this.occurredAt,
  });

  factory ThreatDto.fromJson(Map<String, dynamic> json) => ThreatDto(
    id: json['id']?.toString() ?? '',
    title: json['title']?.toString() ?? '',
    threatType:
        json['threatType']?.toString() ?? json['threat_type']?.toString() ?? '',
    severity: json['severity']?.toString() ?? 'LOW',
    status: json['status']?.toString() ?? 'OPEN',
    associatedActor:
        json['associatedActor']?.toString() ??
        json['associated_actor']?.toString(),
    associatedIp:
        json['associatedIp']?.toString() ?? json['associated_ip']?.toString(),
    mitreTechniqueId:
        json['mitreTechniqueId']?.toString() ??
        json['mitre_technique_id']?.toString(),
    aiAnalysisSummary:
        json['aiAnalysisSummary']?.toString() ??
        json['ai_analysis_summary']?.toString(),
    occurredAt: _parseDate(json['occurredAt'] ?? json['occurred_at']),
  );
}

DateTime? _parseDate(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
