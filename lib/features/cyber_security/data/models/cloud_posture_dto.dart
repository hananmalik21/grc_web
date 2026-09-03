class CloudCoverageConnectorDto {
  final String id;
  final String provider;
  final String name;
  final String status;
  final DateTime? lastSyncAt;
  final int logCount24h;
  final int logCountTotal;

  const CloudCoverageConnectorDto({
    required this.id,
    required this.provider,
    required this.name,
    required this.status,
    this.lastSyncAt,
    this.logCount24h = 0,
    this.logCountTotal = 0,
  });

  factory CloudCoverageConnectorDto.fromJson(Map<String, dynamic> json) =>
      CloudCoverageConnectorDto(
        id: json['id']?.toString() ?? '',
        provider: json['provider']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        status: json['status']?.toString() ?? 'UNKNOWN',
        lastSyncAt: _parseDate(json['lastSyncAt'] ?? json['last_sync_at']),
        logCount24h: _toInt(json['logCount24h'] ?? json['log_count_24h']),
        logCountTotal: _toInt(json['logCountTotal'] ?? json['log_count_total']),
      );
}

class CloudCoverageDashboardDto {
  final List<CloudCoverageConnectorDto> connectors;
  final int totalLogs24h;
  final int totalLogsAllTime;

  const CloudCoverageDashboardDto({
    this.connectors = const [],
    this.totalLogs24h = 0,
    this.totalLogsAllTime = 0,
  });

  factory CloudCoverageDashboardDto.fromJson(Map<String, dynamic> json) =>
      CloudCoverageDashboardDto(
        connectors:
            (json['connectors'] as List<dynamic>?)
                ?.whereType<Map<String, dynamic>>()
                .map(CloudCoverageConnectorDto.fromJson)
                .toList() ??
            const [],
        totalLogs24h: _toInt(json['totalLogs24h'] ?? json['total_logs_24h']),
        totalLogsAllTime: _toInt(
          json['totalLogsAllTime'] ?? json['total_logs_all_time'],
        ),
      );
}

int _toInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
DateTime? _parseDate(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
