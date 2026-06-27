class OrgUnit {
  final String orgUnitId;
  final String orgStructureId;
  final int enterpriseId;
  final String levelCode;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String? parentOrgUnitId;
  final bool isActive;
  final String? managerName;
  final String? managerEmail;
  final String? managerPhone;
  final String? location;
  final String? city;
  final String? address;
  final String? description;

  const OrgUnit({
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OrgUnit && other.orgUnitId == orgUnitId;
  }

  @override
  int get hashCode => orgUnitId.hashCode;
}

class OrgUnitsResponse {
  final List<OrgUnit> data;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  const OrgUnitsResponse({
    required this.data,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });
}
