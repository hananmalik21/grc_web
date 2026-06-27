import '../../domain/models/overtime_configuration/config_info.dart';
import '../../domain/models/overtime_configuration/labor_law_limits.dart';
import '../../domain/models/overtime_configuration/rate_multiplier.dart';
import '../../presentation/providers/overtime_configuration/overtime_configuration_provider.dart';

class OvertimeConfigurationDto {
  final Map<String, dynamic> configInfo;
  final List<Map<String, dynamic>> rateMultipliers;
  final Map<String, dynamic> laborLawLimits;
  final bool isManagerApprovalRequired;
  final bool isHRValidationRequired;

  OvertimeConfigurationDto({
    required this.configInfo,
    required this.rateMultipliers,
    required this.laborLawLimits,
    required this.isManagerApprovalRequired,
    required this.isHRValidationRequired,
  });

  factory OvertimeConfigurationDto.fromJson(Map<String, dynamic> json) {
    return OvertimeConfigurationDto(
      configInfo: json['config'] is Map
          ? Map<String, dynamic>.from(json['config'] as Map)
          : <String, dynamic>{},
      rateMultipliers: (json['rate_types'] as List<dynamic>? ?? [])
          .map(
            (e) =>
                e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{},
          )
          .toList(),
      laborLawLimits: json['labor_limits'] is Map
          ? Map<String, dynamic>.from(json['labor_limits'] as Map)
          : <String, dynamic>{},
      isManagerApprovalRequired:
          json['manager_approval_required'] == true ||
          json['manager_approval_required'] == 1,
      isHRValidationRequired:
          json['hr_validation_required'] == true ||
          json['hr_validation_required'] == 1,
    );
  }

  OvertimeConfiguration toDomain() {
    return OvertimeConfiguration(
      configInfo: ConfigInfo.fromJson(configInfo),
      rateMultipliers: rateMultipliers
          .map((e) => RateMultiplier.fromJson(e))
          .toList(),
      laborLawLimits: LaborLawLimit.fromJson(laborLawLimits),
      isManagerApprovalRequired: isManagerApprovalRequired,
      isHRValidationRequired: isHRValidationRequired,
    );
  }
}
