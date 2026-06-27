import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan_nested_models.dart';

class CompensationPlan {
  final int planId;
  final String planGuid;
  final int enterpriseId;
  final String planCode;
  final String planName;
  final String planTypeCode;
  final String statusCode;
  final String currencyCode;
  final String activeFlag;
  final int? ownerEmployeeId;
  final String? createdBy;
  final DateTime? creationDate;
  final String? lastUpdatedBy;
  final DateTime? lastUpdateDate;

  // New fields for details
  final DateTime? startDate;
  final DateTime? endDate;
  final double? budgetAmount;
  final String? description;
  final PlanOwner? owner;
  final List<PlanAttribute>? attributes;
  final List<PlanBudget>? budgets;
  final List<PlanBusinessUnit>? businessUnits;
  final List<PlanComponent>? components;
  final List<PlanEmploymentType>? employmentTypes;
  final List<PlanGrade>? grades;
  final List<PlanJobFamily>? jobFamilies;
  final List<PlanLocation>? locations;
  final List<PlanPosition>? positions;
  final List<PlanSalaryStructure>? salaryStructures;
  final Map<String, dynamic>? payrollObject;

  const CompensationPlan({
    required this.planId,
    required this.planGuid,
    required this.enterpriseId,
    required this.planCode,
    required this.planName,
    required this.planTypeCode,
    required this.statusCode,
    required this.currencyCode,
    required this.activeFlag,
    required this.ownerEmployeeId,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdatedBy,
    required this.lastUpdateDate,
    this.startDate,
    this.endDate,
    this.budgetAmount,
    this.description,
    this.owner,
    this.attributes,
    this.budgets,
    this.businessUnits,
    this.components,
    this.employmentTypes,
    this.grades,
    this.jobFamilies,
    this.locations,
    this.positions,
    this.salaryStructures,
    this.payrollObject,
  });

  String get displayDescription => description ?? '---';
  String get displayOwnerName => owner?.fullNameEn ?? '---';
  String get displayBusinessUnit =>
      businessUnits?.isNotEmpty == true ? businessUnits!.first.orgUnit?.nameEn ?? '---' : '---';
  String get displayRegion {
    if (locations != null && locations!.isNotEmpty) {
      for (final location in locations!) {
        final name = location.location?.name.trim();
        if (name != null && name.isNotEmpty) return name;

        final type = location.location?.type.trim();
        if (type != null && type.isNotEmpty) return type;
      }
    }

    return '---';
  }

  String get formattedStartDate => startDate != null ? _formatDate(startDate!) : '---';
  String get formattedEndDate => endDate != null ? _formatDate(endDate!) : '---';
  String get formattedCreationDate => creationDate != null ? _formatDate(creationDate!) : '---';
  String get formattedLastUpdateDate => lastUpdateDate != null ? _formatDate(lastUpdateDate!) : '---';

  String get displayBudget => budgetAmount != null ? '$currencyCode ${budgetAmount!.toStringAsFixed(0)}' : '---';
  bool get isPayrollMapped => payrollObject != null;

  List<String> get displayGradeList =>
      grades?.map((e) => e.grade?.number.trim()).where((e) => e != null && e.isNotEmpty).cast<String>().toList() ?? [];

  List<String> get displayJobFamilyList =>
      jobFamilies
          ?.map((e) => e.jobFamily?.nameEn.trim())
          .where((e) => e != null && e.isNotEmpty)
          .cast<String>()
          .toList() ??
      [];

  List<String> get displayBusinessUnitList =>
      businessUnits
          ?.map((e) => e.orgUnit?.nameEn.trim())
          .where((e) => e != null && e.isNotEmpty)
          .cast<String>()
          .toList() ??
      [];

  List<String> get displayLocationList =>
      locations
          ?.map((e) => e.location?.name.trim() ?? e.location?.type.trim())
          .where((e) => e != null && e.isNotEmpty)
          .cast<String>()
          .toList() ??
      [];

  List<String> get displayEmploymentTypeList =>
      employmentTypes?.map((e) => e.typeCode.trim()).where((e) => e.isNotEmpty).toList() ?? [];

  List<String> get displayPositionList =>
      positions
          ?.map((e) => e.position?.titleEn.trim())
          .where((e) => e != null && e.isNotEmpty)
          .cast<String>()
          .toList() ??
      [];

  List<String> get displaySalaryStructureList =>
      salaryStructures
          ?.map((e) => e.structure?.name.trim())
          .where((e) => e != null && e.isNotEmpty)
          .cast<String>()
          .toList() ??
      [];
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Map<String, List<PlanComponent>> get groupedComponentsByType {
    final grouped = <String, List<PlanComponent>>{};
    for (final comp in components ?? <PlanComponent>[]) {
      final type = comp.component?.typeCode ?? 'OTHER';
      grouped.putIfAbsent(type, () => []).add(comp);
    }
    return grouped;
  }
}
