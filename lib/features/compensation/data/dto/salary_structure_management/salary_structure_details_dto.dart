import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_detail_component_dto.dart';
import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_org_scope_parser.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_details.dart';

class SalaryStructureDetailsDto {
  final int structureId;
  final String structureGuid;
  final int enterpriseId;
  final String structureCode;
  final String structureName;
  final String structureTypeCode;
  final String currencyCode;
  final bool isActive;
  final List<String> employmentTypeCodes;
  final List<int> jobFamilyIds;
  final List<String> positionIds;
  final List<int> gradeIds;
  final List<SalaryStructureDetailComponentDto> components;

  const SalaryStructureDetailsDto({
    required this.structureId,
    required this.structureGuid,
    required this.enterpriseId,
    required this.structureCode,
    required this.structureName,
    required this.structureTypeCode,
    required this.currencyCode,
    required this.isActive,
    required this.employmentTypeCodes,
    required this.jobFamilyIds,
    required this.positionIds,
    required this.gradeIds,
    required this.components,
  });

  factory SalaryStructureDetailsDto.fromJson(Map<String, dynamic> json) {
    final data = (json['data'] as Map<String, dynamic>? ?? const <String, dynamic>{});
    final structure = (data['structure'] as Map<String, dynamic>? ?? const <String, dynamic>{});
    final orgScopes = (data['org_scopes'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>().toList();
    final employmentTypes = (data['employment_types'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final orgScopeResult = SalaryStructureOrgScopeParser.parse(orgScopes: orgScopes, employmentTypes: employmentTypes);
    final jobFamilies = (data['job_families'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>().toList();
    final positions = (data['positions'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>().toList();
    final gradeRanges = (data['grade_ranges'] as List<dynamic>? ?? const []).whereType<Map<String, dynamic>>().toList();
    final components = (data['components'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(SalaryStructureDetailComponentDto.fromJson)
        .toList();

    return SalaryStructureDetailsDto(
      structureId: (data['structure_id'] as num?)?.toInt() ?? 0,
      structureGuid: (data['structure_guid'] as String?) ?? '',
      enterpriseId: (data['enterprise_id'] as num?)?.toInt() ?? 0,
      structureCode: (data['structure_code'] as String?) ?? '',
      structureName: (data['structure_name'] as String?) ?? '',
      structureTypeCode: (data['structure_type_code'] as String?) ?? '',
      currencyCode: (structure['currency_code'] as String?) ?? '',
      isActive: _isYes(data['active_flag']),
      employmentTypeCodes: orgScopeResult.employmentTypeCodes,
      jobFamilyIds: jobFamilies
          .map((item) => (item['job_family_id'] as num?)?.toInt())
          .whereType<int>()
          .toSet()
          .toList(),
      positionIds: positions
          .map((item) => (item['position_id'] as String?)?.trim() ?? '')
          .where((id) => id.isNotEmpty)
          .toSet()
          .toList(),
      gradeIds: gradeRanges.map((item) => (item['grade_id'] as num?)?.toInt()).whereType<int>().toSet().toList(),
      components: components,
    );
  }

  SalaryStructureDetails toDomain() {
    return SalaryStructureDetails(
      structureId: structureId,
      structureGuid: structureGuid,
      enterpriseId: enterpriseId,
      structureCode: structureCode,
      structureName: structureName,
      structureTypeCode: structureTypeCode,
      currencyCode: currencyCode,
      isActive: isActive,
      employmentTypeCodes: employmentTypeCodes,
      jobFamilyIds: jobFamilyIds,
      positionIds: positionIds,
      gradeIds: gradeIds,
      components: components.map((e) => e.toDomain()).toList(),
    );
  }

  static bool _isYes(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    return value.toString().trim().toUpperCase() == 'Y';
  }
}
