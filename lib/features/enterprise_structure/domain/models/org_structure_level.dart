import 'package:grc/features/enterprise_structure/data/dto/org_structure_level_dto.dart';
import 'package:flutter/foundation.dart';

@immutable
class OrgStructureLevel {
  final String orgUnitId;
  final String orgStructureId;
  final String? orgStructureName;
  final int enterpriseId;
  final String levelCode;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;

  /// FK (used for save/update)
  final String? parentOrgUnitId;

  /// ✅ Rich parent object (used for UI)
  final ParentUnitDto? parentUnit;

  final bool isActive;
  final String managerName;
  final String managerEmail;
  final String managerPhone;
  final String location;
  final String city;
  final String address;
  final String description;
  final String createdBy;
  final String createdDate;
  final String lastUpdatedBy;
  final String lastUpdatedDate;
  final String lastUpdateLogin;

  const OrgStructureLevel({
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
    required this.managerName,
    required this.managerEmail,
    required this.managerPhone,
    required this.location,
    required this.city,
    required this.address,
    required this.description,
    required this.createdBy,
    required this.createdDate,
    required this.lastUpdatedBy,
    required this.lastUpdatedDate,
    required this.lastUpdateLogin,
  });

  /// ✅ Preferred display name
  String get displayName =>
      orgUnitNameEn.isNotEmpty ? orgUnitNameEn : orgUnitNameAr;

  /// ✅ Parent display helpers
  String get parentName => parentUnit?.name ?? '';
  String get parentLevel => parentUnit?.level ?? '';
}
