class OrgUnitHierarchyItem {
  const OrgUnitHierarchyItem({
    required this.displayLevel,
    required this.orgUnitId,
    required this.orgUnitNameEn,
    required this.levelCode,
    this.parentOrgUnitId,
  });

  final int displayLevel;
  final String orgUnitId;
  final String orgUnitNameEn;
  final String levelCode;
  final String? parentOrgUnitId;

  factory OrgUnitHierarchyItem.fromJson(Map<String, dynamic> json) {
    return OrgUnitHierarchyItem(
      displayLevel: (json['display_level'] as num).toInt(),
      orgUnitId: json['org_unit_id'] as String,
      orgUnitNameEn: json['org_unit_name_en'] as String,
      levelCode: json['level_code'] as String,
      parentOrgUnitId: json['parent_org_unit_id'] as String?,
    );
  }
}
