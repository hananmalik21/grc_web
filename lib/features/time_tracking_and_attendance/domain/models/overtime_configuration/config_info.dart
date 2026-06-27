class ConfigInfo {
  final String otConfigId;
  final String configName;
  final DateTime? effectiveStartDate;
  final DateTime? effectiveEndDate;

  ConfigInfo({
    this.otConfigId = '',
    this.configName = '',
    this.effectiveStartDate,
    this.effectiveEndDate,
  });

  ConfigInfo copyWith({
    String? otConfigId,
    String? configName,
    DateTime? effectiveStartDate,
    DateTime? effectiveEndDate,
  }) {
    return ConfigInfo(
      otConfigId: otConfigId ?? this.otConfigId,
      configName: configName ?? this.configName,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      effectiveEndDate: effectiveEndDate ?? this.effectiveEndDate,
    );
  }

  factory ConfigInfo.fromJson(Map<String, dynamic> json) {
    return ConfigInfo(
      otConfigId: json['ot_config_id']?.toString() ?? '',
      configName: json['config_name']?.toString() ?? '',
      effectiveStartDate: DateTime.tryParse(json['effective_start_date'] ?? ""),
      effectiveEndDate: DateTime.tryParse(json['effective_end_date'] ?? ""),
    );
  }
}
