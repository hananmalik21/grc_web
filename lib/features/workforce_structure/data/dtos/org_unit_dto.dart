import 'package:grc/features/workforce_structure/domain/models/org_unit.dart';

class OrgUnitDto {
  final String orgUnitId;
  final String orgStructureId;
  final int enterpriseId;
  final String levelCode;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String? parentOrgUnitId;
  final String isActive;
  final String? managerName;
  final String? managerEmail;
  final String? managerPhone;
  final String? location;
  final String? city;
  final String? address;
  final String? description;

  const OrgUnitDto({
    required this.orgUnitId,
    required this.orgStructureId,
    required this.enterpriseId,
    required this.levelCode,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    this.parentOrgUnitId,
    required this.isActive,
    this.managerName,
    this.managerEmail,
    this.managerPhone,
    this.location,
    this.city,
    this.address,
    this.description,
  });

  factory OrgUnitDto.fromJson(Map<String, dynamic> json) {
    return OrgUnitDto(
      orgUnitId: json['org_unit_id'] as String,
      orgStructureId: (json['org_structure_id'] as String?) ?? (json['org_structure_id'] as num?)?.toString() ?? '',
      enterpriseId: json['enterprise_id'] as int,
      levelCode: json['level_code'] as String,
      orgUnitCode: json['org_unit_code'] as String,
      orgUnitNameEn: json['org_unit_name_en'] as String? ?? '',
      orgUnitNameAr: json['org_unit_name_ar'] as String? ?? '',
      parentOrgUnitId: (json['parent_org_unit_id'] as String?) ?? (json['parent_org_unit_id'] as num?)?.toString(),
      isActive: json['is_active'] as String,
      managerName: json['manager_name'] as String?,
      managerEmail: json['manager_email'] as String?,
      managerPhone: json['manager_phone'] as String?,
      location: json['location'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
    );
  }

  OrgUnit toDomain() {
    return OrgUnit(
      orgUnitId: orgUnitId,
      orgStructureId: orgStructureId,
      enterpriseId: enterpriseId,
      levelCode: levelCode,
      orgUnitCode: orgUnitCode,
      orgUnitNameEn: orgUnitNameEn,
      orgUnitNameAr: orgUnitNameAr,
      parentOrgUnitId: parentOrgUnitId,
      isActive: isActive == 'Y',
      managerName: managerName,
      managerEmail: managerEmail,
      managerPhone: managerPhone,
      location: location,
      city: city,
      address: address,
      description: description,
    );
  }
}

class OrgUnitsResponseDto {
  final List<OrgUnitDto> data;
  final Map<String, dynamic> meta;

  const OrgUnitsResponseDto({required this.data, required this.meta});

  factory OrgUnitsResponseDto.fromJson(Map<String, dynamic> json) {
    return OrgUnitsResponseDto(
      data: (json['data'] as List<dynamic>).map((e) => OrgUnitDto.fromJson(e as Map<String, dynamic>)).toList(),
      meta: json['meta'] as Map<String, dynamic>,
    );
  }

  OrgUnitsResponse toDomain() {
    final pagination = meta['pagination'] as Map<String, dynamic>;
    return OrgUnitsResponse(
      data: data.map((e) => e.toDomain()).toList(),
      total: pagination['total'] as int,
      page: pagination['page'] as int,
      pageSize: pagination['page_size'] as int,
      totalPages: pagination['total_pages'] as int,
      hasNext: pagination['has_next'] as bool,
      hasPrevious: pagination['has_previous'] as bool,
    );
  }
}
