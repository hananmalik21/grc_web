class ApiLeaveType {
  final int id;
  final String guid;
  final int tenantId;
  final String code;
  final String nameEn;
  final String nameAr;
  final String? descriptionEn;
  final String? descriptionAr;
  final bool isPaid;
  final bool requiresDocuments;
  final int? maxDaysPerYear;
  final bool isActive;

  const ApiLeaveType({
    required this.id,
    required this.guid,
    required this.tenantId,
    required this.code,
    required this.nameEn,
    required this.nameAr,
    this.descriptionEn,
    this.descriptionAr,
    required this.isPaid,
    required this.requiresDocuments,
    this.maxDaysPerYear,
    required this.isActive,
  });

  String get displayName => nameEn;
  String get displayNameAr => nameAr;
}
