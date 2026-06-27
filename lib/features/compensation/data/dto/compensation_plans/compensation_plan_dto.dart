import 'package:grc/features/compensation/data/dto/compensation_plans/compensation_plan_nested_dtos.dart';
import 'package:grc/features/compensation/domain/models/compensation_plans/compensation_plan.dart';

class CompensationPlanDto {
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

  final DateTime? startDate;
  final DateTime? endDate;
  final double? budgetAmount;
  final String? description;
  final PlanOwnerDto? owner;
  final List<PlanAttributeDto>? attributes;
  final List<PlanBudgetDto>? budgets;
  final List<PlanBusinessUnitDto>? businessUnits;
  final List<PlanComponentDto>? components;
  final List<PlanEmploymentTypeDto>? employmentTypes;
  final List<PlanGradeDto>? grades;
  final List<PlanJobFamilyDto>? jobFamilies;
  final List<PlanLocationDto>? locations;
  final List<PlanPositionDto>? positions;
  final List<PlanSalaryStructureDto>? salaryStructures;
  final Map<String, dynamic>? payrollObject;

  const CompensationPlanDto({
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

  factory CompensationPlanDto.fromJson(Map<String, dynamic> json) {
    return CompensationPlanDto(
      planId: (json['plan_id'] as num?)?.toInt() ?? 0,
      planGuid: (json['plan_guid'] as String?) ?? '',
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      planCode: (json['plan_code'] as String?) ?? '',
      planName: (json['plan_name'] as String?) ?? '',
      planTypeCode: (json['plan_type_code'] as String?) ?? '',
      statusCode: (json['status_code'] as String?) ?? '',
      currencyCode: (json['currency_code'] as String?) ?? '',
      activeFlag: (json['active_flag'] as String?) ?? '',
      ownerEmployeeId: (json['owner_employee_id'] as num?)?.toInt(),
      createdBy: json['created_by'] as String?,
      creationDate: DateTime.tryParse((json['creation_date'] as String?) ?? ''),
      lastUpdatedBy: json['last_updated_by'] as String?,
      lastUpdateDate: DateTime.tryParse((json['last_update_date'] as String?) ?? ''),
      startDate: DateTime.tryParse((json['start_date'] as String?) ?? ''),
      endDate: DateTime.tryParse((json['end_date'] as String?) ?? ''),
      budgetAmount: (json['budget_amount'] as num?)?.toDouble(),
      description: json['description'] as String?,
      owner: json['owner_obj'] != null ? PlanOwnerDto.fromJson(json['owner_obj'] as Map<String, dynamic>) : null,
      attributes: (json['plan_attributes_json'] as List?)
          ?.map((e) => PlanAttributeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      budgets: (json['plan_budgets_json'] as List?)
          ?.map((e) => PlanBudgetDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      businessUnits: (json['plan_business_units_json'] as List?)
          ?.map((e) => PlanBusinessUnitDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      components: ((json['plan_components_json'] ?? json['components']) as List?)
          ?.map((e) => PlanComponentDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      employmentTypes: (json['plan_employment_types_json'] as List?)
          ?.map((e) => PlanEmploymentTypeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      grades: (json['plan_grades_json'] as List?)
          ?.map((e) => PlanGradeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      jobFamilies: (json['plan_job_families_json'] as List?)
          ?.map((e) => PlanJobFamilyDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      locations: (json['plan_locations_json'] as List?)
          ?.map((e) => PlanLocationDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      positions: (json['plan_positions_json'] as List?)
          ?.map((e) => PlanPositionDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      salaryStructures: (json['plan_salary_structures_json'] as List?)
          ?.map((e) => PlanSalaryStructureDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      payrollObject: (json['payroll_obj'] ?? json['payroll_object']) as Map<String, dynamic>?,
    );
  }

  CompensationPlan toDomain() {
    return CompensationPlan(
      planId: planId,
      planGuid: planGuid,
      enterpriseId: enterpriseId,
      planCode: _safeText(planCode),
      planName: _safeText(planName),
      planTypeCode: _safeText(planTypeCode),
      statusCode: _normalizeStatus(statusCode),
      currencyCode: _normalizeCurrency(currencyCode),
      activeFlag: _normalizeFlag(activeFlag),
      ownerEmployeeId: ownerEmployeeId,
      createdBy: _safeNullableText(createdBy),
      creationDate: creationDate,
      lastUpdatedBy: _safeNullableText(lastUpdatedBy),
      lastUpdateDate: lastUpdateDate,
      startDate: startDate,
      endDate: endDate,
      budgetAmount: budgetAmount,
      description: description,
      owner: owner?.toDomain(),
      attributes: attributes?.map((e) => e.toDomain()).toList(),
      budgets: budgets?.map((e) => e.toDomain()).toList(),
      businessUnits: businessUnits?.map((e) => e.toDomain()).toList(),
      components: components?.map((e) => e.toDomain()).toList(),
      employmentTypes: employmentTypes?.map((e) => e.toDomain()).toList(),
      grades: grades?.map((e) => e.toDomain()).toList(),
      jobFamilies: jobFamilies?.map((e) => e.toDomain()).toList(),
      locations: locations?.map((e) => e.toDomain()).toList(),
      positions: positions?.map((e) => e.toDomain()).toList(),
      salaryStructures: salaryStructures?.map((e) => e.toDomain()).toList(),
      payrollObject: payrollObject,
    );
  }

  String _safeText(String value) {
    final normalized = value.trim();
    return normalized.isEmpty ? '---' : normalized;
  }

  String? _safeNullableText(String? value) {
    if (value == null) return null;
    final normalized = value.trim();
    return normalized.isEmpty ? null : normalized;
  }

  String _normalizeStatus(String value) {
    final normalized = value.trim().toUpperCase();
    return normalized.isEmpty ? 'DRAFT' : normalized;
  }

  String _normalizeCurrency(String value) {
    final normalized = value.trim().toUpperCase();
    return normalized.isEmpty ? '---' : normalized;
  }

  String _normalizeFlag(String value) {
    final normalized = value.trim().toUpperCase();
    return normalized == 'Y' ? 'Y' : 'N';
  }
}
