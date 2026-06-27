import 'package:grc/features/compensation/data/dto/salary_structure_management/salary_structure_location_dto.dart';
import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_item.dart';

class SalaryStructureItemDto {
  final int structureId;
  final String structureGuid;
  final int enterpriseId;
  final String structureCode;
  final String structureName;
  final String structureTypeCode;
  final SalaryStructureLocationDto? locationObj;
  final String activeFlag;
  final String createdBy;
  final DateTime? creationDate;
  final String lastUpdatedBy;
  final DateTime? lastUpdateDate;

  const SalaryStructureItemDto({
    required this.structureId,
    required this.structureGuid,
    required this.enterpriseId,
    required this.structureCode,
    required this.structureName,
    required this.structureTypeCode,
    required this.locationObj,
    required this.activeFlag,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdatedBy,
    required this.lastUpdateDate,
  });

  factory SalaryStructureItemDto.fromJson(Map<String, dynamic> json) {
    return SalaryStructureItemDto(
      structureId: (json['structure_id'] as num?)?.toInt() ?? 0,
      structureGuid: (json['structure_guid'] as String?) ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      structureCode: (json['structure_code'] as String?) ?? '',
      structureName: (json['structure_name'] as String?) ?? '',
      structureTypeCode: (json['structure_type_code'] as String?) ?? '',
      locationObj: _tryParseLocation(json['location_obj']),
      activeFlag: (json['active_flag'] as String?) ?? 'N',
      createdBy: (json['created_by'] as String?) ?? '',
      creationDate: _tryParseDate(json['creation_date']),
      lastUpdatedBy: (json['last_updated_by'] as String?) ?? '',
      lastUpdateDate: _tryParseDate(json['last_update_date']),
    );
  }

  SalaryStructureItem toDomain() {
    return SalaryStructureItem(
      structureId: structureId,
      structureGuid: structureGuid,
      enterpriseId: enterpriseId,
      structureCode: structureCode,
      structureName: structureName,
      structureTypeCode: structureTypeCode,
      locationObj: locationObj?.toDomain(),
      activeFlag: activeFlag,
      createdBy: createdBy,
      creationDate: creationDate,
      lastUpdatedBy: lastUpdatedBy,
      lastUpdateDate: lastUpdateDate,
    );
  }

  static DateTime? _tryParseDate(dynamic value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  static SalaryStructureLocationDto? _tryParseLocation(dynamic value) {
    if (value is! Map<String, dynamic> || value.isEmpty) {
      return null;
    }
    return SalaryStructureLocationDto.fromJson(value);
  }
}
