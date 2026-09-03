class IamPrincipalDto {
  final String id;
  final String provider;
  final String externalPrincipalId;
  final String displayName;
  final String principalType;
  final bool? mfaEnrolled;
  final bool isPrivileged;
  final String status;
  final DateTime? lastLoginAt;
  final DateTime? lastSyncedAt;

  const IamPrincipalDto({
    required this.id,
    required this.provider,
    required this.externalPrincipalId,
    required this.displayName,
    required this.principalType,
    required this.mfaEnrolled,
    required this.isPrivileged,
    required this.status,
    this.lastLoginAt,
    this.lastSyncedAt,
  });

  factory IamPrincipalDto.fromJson(Map<String, dynamic> json) =>
      IamPrincipalDto(
        id: json['id']?.toString() ?? '',
        provider: json['provider']?.toString() ?? '',
        externalPrincipalId:
            json['externalPrincipalId']?.toString() ??
            json['external_principal_id']?.toString() ??
            '',
        displayName:
            json['displayName']?.toString() ??
            json['display_name']?.toString() ??
            '',
        principalType:
            json['principalType']?.toString() ??
            json['principal_type']?.toString() ??
            'UNKNOWN',
        mfaEnrolled: _parseBool(json['mfaEnrolled'] ?? json['mfa_enrolled']),
        isPrivileged:
            _parseBool(json['isPrivileged'] ?? json['is_privileged']) ?? false,
        status: json['status']?.toString() ?? 'UNKNOWN',
        lastLoginAt: _parseDate(json['lastLoginAt'] ?? json['last_login_at']),
        lastSyncedAt: _parseDate(
          json['lastSyncedAt'] ?? json['last_synced_at'],
        ),
      );
}

class IamPostureSummaryDto {
  final int totalPrincipals;
  final int withoutMfa;
  final int privilegedWithoutMfa;
  final int disabledButPrivileged;

  const IamPostureSummaryDto({
    this.totalPrincipals = 0,
    this.withoutMfa = 0,
    this.privilegedWithoutMfa = 0,
    this.disabledButPrivileged = 0,
  });

  factory IamPostureSummaryDto.fromJson(Map<String, dynamic> json) =>
      IamPostureSummaryDto(
        totalPrincipals: _toInt(
          json['totalPrincipals'] ?? json['total_principals'],
        ),
        withoutMfa: _toInt(json['withoutMfa'] ?? json['without_mfa']),
        privilegedWithoutMfa: _toInt(
          json['privilegedWithoutMfa'] ?? json['privileged_without_mfa'],
        ),
        disabledButPrivileged: _toInt(
          json['disabledButPrivileged'] ?? json['disabled_but_privileged'],
        ),
      );
}

bool? _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return value.toLowerCase() == 'true' || value == '1';
  return null;
}

int _toInt(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;

DateTime? _parseDate(dynamic value) =>
    value == null ? null : DateTime.tryParse(value.toString());
