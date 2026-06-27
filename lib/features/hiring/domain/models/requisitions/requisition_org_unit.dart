class RequisitionOrgUnit {
  const RequisitionOrgUnit({required this.levelCode, this.orgUnitName, this.orgUnitNameEn, this.orgUnitCode});

  final String levelCode;
  final String? orgUnitName;
  final String? orgUnitNameEn;
  final String? orgUnitCode;

  String get displayName {
    final en = orgUnitNameEn?.trim();
    if (en != null && en.isNotEmpty) return en;
    final name = orgUnitName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return orgUnitCode?.trim() ?? '';
  }
}
