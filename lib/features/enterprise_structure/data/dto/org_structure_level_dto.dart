import 'package:grc/features/enterprise_structure/domain/models/org_structure_level.dart';
import 'package:intl/intl.dart';

class ParentUnitDto {
  final String id;
  final String name;

  final String? level;

  const ParentUnitDto({required this.id, required this.name, this.level});

  factory ParentUnitDto.fromJson(Map<String, dynamic> json) {
    final idValue = json['id'];
    final idString = idValue is String
        ? idValue
        : idValue is num
        ? idValue.toString()
        : idValue?.toString() ?? '';

    return ParentUnitDto(id: idString, name: json['name'] as String? ?? '', level: json['level'] as String? ?? "");
  }

  Map<String, dynamic> toJson() => {'id': id, 'name': name, if (level != null) 'level': level};
}

class OrgStructureLevelDto {
  final String orgUnitId;
  final String orgStructureId;
  final String? orgStructureName;
  final int enterpriseId;
  final String levelCode;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;

  final String? parentOrgUnitId;

  final ParentUnitDto? parentUnit;

  final String isActive;
  final String? managerName;
  final String? managerEmail;
  final String? managerPhone;
  final String? location;
  final String? city;
  final String? address;
  final String? description;
  final String? createdBy;
  final String? createdDate;
  final String? lastUpdatedBy;
  final String? lastUpdatedDate;
  final String? lastUpdateLogin;

  const OrgStructureLevelDto({
    required this.orgUnitId,
    required this.orgStructureId,
    this.orgStructureName,
    required this.enterpriseId,
    required this.levelCode,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    this.parentOrgUnitId,
    this.parentUnit,
    required this.isActive,
    this.managerName,
    this.managerEmail,
    this.managerPhone,
    this.location,
    this.city,
    this.address,
    this.description,
    this.createdBy,
    this.createdDate,
    this.lastUpdatedBy,
    this.lastUpdatedDate,
    this.lastUpdateLogin,
  });

  static String _parseIdToString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is num) return value.toString();
    return value.toString();
  }

  factory OrgStructureLevelDto.fromJson(Map<String, dynamic> json) {
    final parentId = _parseIdToString(json['parent_org_unit_id'] ?? json['parentOrgUnitId']);

    ParentUnitDto? parentUnit;
    final parentUnitJson = json['parent_unit'];
    if (parentUnitJson is Map<String, dynamic>) {
      parentUnit = ParentUnitDto.fromJson(parentUnitJson);
    } else {
      final fallbackParentId = _parseIdToString(json['parent_org_unit_id'] ?? json['parentOrgUnitId']);
      final fallbackParentName = json['parent_name'] as String?;
      if (fallbackParentId.isNotEmpty) {
        parentUnit = ParentUnitDto(id: fallbackParentId, name: fallbackParentName ?? '');
      }
    }

    return OrgStructureLevelDto(
      orgUnitId: _parseIdToString(json['org_unit_id'] ?? json['orgUnitId'] ?? json["id"]),
      orgStructureId: _parseIdToString(json['org_structure_id'] ?? json['orgStructureId'] ?? ''),
      orgStructureName: json['org_structure_name'] as String? ?? json['orgStructureName'] as String?,
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? (json['enterpriseId'] as num?)?.toInt() ?? 0,
      levelCode: json['level_code'] as String? ?? json['levelCode'] as String? ?? json["level"] ?? '',
      orgUnitCode: json['org_unit_code'] as String? ?? json['orgUnitCode'] as String? ?? '',
      orgUnitNameEn: json['org_unit_name_en'] as String? ?? json['orgUnitNameEn'] as String? ?? json["name"] ?? '',
      orgUnitNameAr: json['org_unit_name_ar'] as String? ?? json['orgUnitNameAr'] as String? ?? '',
      parentOrgUnitId: parentId,
      parentUnit: parentUnit,
      isActive: json['is_active'] as String? ?? json['isActive'] as String? ?? 'N',
      managerName: json['manager_name'] as String? ?? json['managerName'] as String?,
      managerEmail: json['manager_email'] as String? ?? json['managerEmail'] as String?,
      managerPhone: json['manager_phone'] as String? ?? json['managerPhone'] as String?,
      location: json['location'] as String?,
      city: json['city'] as String?,
      address: json['address'] as String?,
      description: json['description'] as String?,
      createdBy: json['created_by'] as String? ?? json['createdBy'] as String?,
      createdDate: json['created_date'] as String? ?? json['created_date'] as String?,
      lastUpdatedBy: json['last_updated_by'] as String? ?? json['lastUpdatedBy'] as String?,
      lastUpdatedDate: json['last_updated_date'] as String? ?? json['last_updated_date'] as String?,
      lastUpdateLogin: json['last_update_login'] as String? ?? json['lastUpdateLogin'] as String?,
    );
  }

  OrgStructureLevel toDomain() {
    String formattedLastUpdatedDate = lastUpdatedDate ?? '';
    if (formattedLastUpdatedDate.isNotEmpty) {
      try {
        final dateTime = DateTime.parse(formattedLastUpdatedDate);
        formattedLastUpdatedDate = DateFormat('yyyy-MM-dd').format(dateTime);
      } catch (_) {}
    }

    return OrgStructureLevel(
      orgUnitId: orgUnitId,
      orgStructureId: orgStructureId,
      orgStructureName: orgStructureName,
      enterpriseId: enterpriseId,
      levelCode: levelCode,
      orgUnitCode: orgUnitCode,
      orgUnitNameEn: orgUnitNameEn,
      orgUnitNameAr: orgUnitNameAr,
      parentOrgUnitId: parentOrgUnitId,
      parentUnit: parentUnit,
      isActive: isActive.toUpperCase() == 'Y',
      managerName: managerName ?? '',
      managerEmail: managerEmail ?? '',
      managerPhone: managerPhone ?? '',
      location: location ?? '',
      city: city ?? '',
      address: address ?? '',
      description: description ?? '',
      createdBy: createdBy ?? '',
      createdDate: createdDate ?? '',
      lastUpdatedBy: lastUpdatedBy ?? '',
      lastUpdatedDate: formattedLastUpdatedDate,
      lastUpdateLogin: lastUpdateLogin ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'org_unit_id': orgUnitId,
      'org_structure_id': orgStructureId,
      'enterprise_id': enterpriseId,
      'level_code': levelCode,
      'org_unit_code': orgUnitCode,
      'org_unit_name_en': orgUnitNameEn,
      'org_unit_name_ar': orgUnitNameAr,
      if (parentOrgUnitId != null) 'parentId': parentOrgUnitId,
      if (parentUnit != null) 'parent_unit': parentUnit!.toJson(),
      'is_active': isActive,
      if (managerName != null) 'manager_name': managerName,
      if (managerEmail != null) 'manager_email': managerEmail,
      if (managerPhone != null) 'manager_phone': managerPhone,
      if (location != null) 'location': location,
      if (city != null) 'city': city,
      if (address != null) 'address': address,
      if (description != null) 'description': description,
      if (createdBy != null) 'created_by': createdBy,
      if (createdDate != null) 'created_date': createdDate,
      if (lastUpdatedBy != null) 'last_updated_by': lastUpdatedBy,
      if (lastUpdatedDate != null) 'last_updated_date': lastUpdatedDate,
      if (lastUpdateLogin != null) 'last_update_login': lastUpdateLogin,
    };
  }
}
