class TelemetryLogDto {
  final String id;
  final String provider;
  final String actorIdentity;
  final String eventName;
  final String category;
  final String sourceIp;
  final String country;
  final bool? mfaUsed;
  final String status;
  final Map<String, dynamic> rawPayload;
  final DateTime? occurredAt;

  const TelemetryLogDto({
    required this.id,
    required this.provider,
    required this.actorIdentity,
    required this.eventName,
    required this.category,
    required this.sourceIp,
    required this.country,
    required this.mfaUsed,
    required this.status,
    required this.rawPayload,
    this.occurredAt,
  });

  factory TelemetryLogDto.fromJson(Map<String, dynamic> json) =>
      TelemetryLogDto(
        id: json['id']?.toString() ?? '',
        provider: json['provider']?.toString() ?? '',
        actorIdentity:
            (json['actorIdentity'] ?? json['actor_identity'])?.toString() ?? '',
        eventName: (json['eventName'] ?? json['event_name'])?.toString() ?? '',
        category: json['category']?.toString() ?? '',
        sourceIp: (json['sourceIp'] ?? json['source_ip'])?.toString() ?? '',
        country: json['country']?.toString() ?? '',
        mfaUsed: _bool(json['mfaUsed'] ?? json['mfa_used']),
        status: json['status']?.toString() ?? '',
        rawPayload: json['rawPayload'] is Map
            ? Map<String, dynamic>.from(json['rawPayload'] as Map)
            : const {},
        occurredAt: _date(json['occurredAt'] ?? json['occurred_at']),
      );
}

class TelemetryIngestResultDto {
  final int ingested;
  final int threatsCreated;

  const TelemetryIngestResultDto({
    required this.ingested,
    required this.threatsCreated,
  });

  factory TelemetryIngestResultDto.fromJson(Map<String, dynamic> json) =>
      TelemetryIngestResultDto(
        ingested: _int(json['ingested']),
        threatsCreated: _int(json['threatsCreated'] ?? json['threats_created']),
      );
}

bool? _bool(dynamic value) {
  if (value is bool) return value;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  if (value is num) return value != 0;
  return null;
}

int _int(dynamic value) =>
    value is num ? value.toInt() : int.tryParse('$value') ?? 0;
DateTime? _date(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
