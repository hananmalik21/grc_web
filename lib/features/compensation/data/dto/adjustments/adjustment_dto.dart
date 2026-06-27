import '../../../domain/models/adjustments/adjustment.dart';

class AdjustmentResponseDto {
  final bool success;
  final String message;
  final List<AdjustmentDto> data;
  final PaginationDto pagination;

  AdjustmentResponseDto({required this.success, required this.message, required this.data, required this.pagination});

  factory AdjustmentResponseDto.fromJson(Map<String, dynamic> json) {
    return AdjustmentResponseDto(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List?)?.map((e) => AdjustmentDto.fromJson(e)).toList() ?? [],
      pagination: PaginationDto.fromJson(json['pagination'] ?? {}),
    );
  }
}

class AdjustmentDto {
  final int adjustmentId;
  final String adjustmentGuid;
  final int enterpriseId;
  final int employeeId;
  final int? planId;
  final int? componentId;
  final String adjustmentType;
  final String effectiveDate;
  final String reasonCode;
  final String? budgetCode;
  final String? justificationText;
  final String? performanceRating;
  final String? internalNotes;
  final String status;
  final String activeFlag;
  final String createdBy;
  final String creationDate;
  final String lastUpdatedBy;
  final String lastUpdateDate;
  final String employeeGuid;
  final String? employeeName;
  final String firstNameEn;
  final String middleNameEn;
  final String lastNameEn;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String? familyNameAr;
  final String employeeNumber;
  final List<AdjustmentOrgUnitDto> orgStructureList;
  final dynamic totalSalary;
  final dynamic previousSalary;
  final dynamic salaryDifferencePercent;
  final List<AdjustmentAssignmentDetailDto> assignmentDetailsJson;
  final List<dynamic> fileUrls;

  AdjustmentDto({
    required this.adjustmentId,
    required this.adjustmentGuid,
    required this.enterpriseId,
    required this.employeeId,
    this.planId,
    this.componentId,
    required this.adjustmentType,
    required this.effectiveDate,
    required this.reasonCode,
    this.budgetCode,
    this.justificationText,
    this.performanceRating,
    this.internalNotes,
    required this.status,
    required this.activeFlag,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdatedBy,
    required this.lastUpdateDate,
    required this.employeeGuid,
    this.employeeName,
    required this.firstNameEn,
    required this.middleNameEn,
    required this.lastNameEn,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    this.familyNameAr,
    required this.employeeNumber,
    required this.orgStructureList,
    required this.totalSalary,
    required this.previousSalary,
    required this.salaryDifferencePercent,
    required this.assignmentDetailsJson,
    required this.fileUrls,
  });

  factory AdjustmentDto.fromJson(Map<String, dynamic> json) {
    return AdjustmentDto(
      adjustmentId: json['adjustment_id'] ?? 0,
      adjustmentGuid: json['adjustment_guid'] ?? '',
      enterpriseId: json['enterprise_id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      planId: json['plan_id'],
      componentId: json['component_id'],
      adjustmentType: json['adjustment_type'] ?? '',
      effectiveDate: json['effective_date'] ?? '',
      reasonCode: json['reason_code'] ?? '',
      budgetCode: json['budget_code'],
      justificationText: json['justification_text'],
      performanceRating: json['performance_rating'],
      internalNotes: json['internal_notes'],
      status: json['status'] ?? '',
      activeFlag: json['active_flag'] ?? '',
      createdBy: json['created_by'] ?? '',
      creationDate: json['creation_date'] ?? '',
      lastUpdatedBy: json['last_updated_by'] ?? '',
      lastUpdateDate: json['last_update_date'] ?? '',
      employeeGuid: json['employee_guid'] ?? '',
      employeeName: json['employee_name'],
      firstNameEn: json['first_name_en'] ?? '',
      middleNameEn: json['middle_name_en'] ?? '',
      lastNameEn: json['last_name_en'] ?? '',
      firstNameAr: json['first_name_ar'],
      middleNameAr: json['middle_name_ar'],
      lastNameAr: json['last_name_ar'],
      familyNameAr: json['family_name_ar'],
      employeeNumber: json['employee_number'] ?? '',
      orgStructureList:
          (json['org_structure_list'] as List?)?.map((e) => AdjustmentOrgUnitDto.fromJson(e)).toList() ?? [],
      totalSalary: json['total_salary'] ?? 0,
      previousSalary: json['previous_salary'] ?? 0,
      salaryDifferencePercent: json['salary_difference_percent'] ?? 0,
      assignmentDetailsJson:
          (json['assignment_details_json'] as List?)?.map((e) => AdjustmentAssignmentDetailDto.fromJson(e)).toList() ??
          [],
      fileUrls: json['file_urls'] ?? [],
    );
  }

  Adjustment toDomain() {
    return Adjustment(
      adjustmentId: adjustmentId,
      adjustmentGuid: adjustmentGuid,
      enterpriseId: enterpriseId,
      employeeId: employeeId,
      planId: planId,
      componentId: componentId,
      adjustmentType: adjustmentType,
      effectiveDate: DateTime.tryParse(effectiveDate) ?? DateTime.now(),
      reasonCode: reasonCode,
      budgetCode: budgetCode,
      justificationText: justificationText,
      performanceRating: performanceRating,
      internalNotes: internalNotes,
      status: status,
      activeFlag: activeFlag,
      createdBy: createdBy,
      creationDate: DateTime.tryParse(creationDate) ?? DateTime.now(),
      lastUpdatedBy: lastUpdatedBy,
      lastUpdateDate: DateTime.tryParse(lastUpdateDate) ?? DateTime.now(),
      employeeGuid: employeeGuid,
      employeeName: employeeName,
      firstNameEn: firstNameEn,
      middleNameEn: middleNameEn,
      lastNameEn: lastNameEn,
      firstNameAr: firstNameAr,
      middleNameAr: middleNameAr,
      lastNameAr: lastNameAr,
      familyNameAr: familyNameAr,
      employeeNumber: employeeNumber,
      orgStructureList: orgStructureList.map((e) => e.toDomain()).toList(),
      totalSalary: (totalSalary is num) ? totalSalary.toDouble() : 0.0,
      previousSalary: (previousSalary is num) ? previousSalary.toDouble() : 0.0,
      salaryDifferencePercent: (salaryDifferencePercent is num) ? salaryDifferencePercent.toDouble() : 0.0,
      assignmentDetails: assignmentDetailsJson.map((e) => e.toDomain()).toList(),
      fileUrls: fileUrls.map((e) => e.toString()).toList(),
    );
  }
}

class AdjustmentOrgUnitDto {
  final int level;
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String levelCode;
  final String status;
  final String isActive;

  AdjustmentOrgUnitDto({
    required this.level,
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    required this.levelCode,
    required this.status,
    required this.isActive,
  });

  factory AdjustmentOrgUnitDto.fromJson(Map<String, dynamic> json) {
    return AdjustmentOrgUnitDto(
      level: json['level'] ?? 0,
      orgUnitId: json['org_unit_id'] ?? '',
      orgUnitCode: json['org_unit_code'] ?? '',
      orgUnitNameEn: json['org_unit_name_en'] ?? '',
      orgUnitNameAr: json['org_unit_name_ar'] ?? '',
      levelCode: json['level_code'] ?? '',
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? '',
    );
  }

  AdjustmentOrgUnit toDomain() {
    return AdjustmentOrgUnit(
      level: level,
      orgUnitId: orgUnitId,
      orgUnitCode: orgUnitCode,
      orgUnitNameEn: orgUnitNameEn,
      orgUnitNameAr: orgUnitNameAr,
      levelCode: levelCode,
      status: status,
      isActive: isActive,
    );
  }
}

class AdjustmentAssignmentDetailDto {
  final int assignmentDetailId;
  final String assignmentDetailGuid;
  final int enterpriseId;
  final int employeeId;
  final int planId;
  final int adjustmentId;
  final String changeSource;
  final String currencyCode;
  final int componentId;
  final dynamic amount;
  final String effectiveStartDate;
  final String? effectiveEndDate;
  final String activeFlag;
  final String createdBy;
  final String creationDate;
  final String lastUpdatedBy;
  final String lastUpdateDate;
  final AdjustmentComponentDto? component;

  AdjustmentAssignmentDetailDto({
    required this.assignmentDetailId,
    required this.assignmentDetailGuid,
    required this.enterpriseId,
    required this.employeeId,
    required this.planId,
    required this.adjustmentId,
    required this.changeSource,
    required this.currencyCode,
    required this.componentId,
    required this.amount,
    required this.effectiveStartDate,
    this.effectiveEndDate,
    required this.activeFlag,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdatedBy,
    required this.lastUpdateDate,
    this.component,
  });

  factory AdjustmentAssignmentDetailDto.fromJson(Map<String, dynamic> json) {
    return AdjustmentAssignmentDetailDto(
      assignmentDetailId: json['assignment_detail_id'] ?? 0,
      assignmentDetailGuid: json['assignment_detail_guid'] ?? '',
      enterpriseId: json['enterprise_id'] ?? 0,
      employeeId: json['employee_id'] ?? 0,
      planId: json['plan_id'] ?? 0,
      adjustmentId: json['adjustment_id'] ?? 0,
      changeSource: json['change_source'] ?? '',
      currencyCode: json['currency_code'] ?? '',
      componentId: json['component_id'] ?? 0,
      amount: json['amount'] ?? 0,
      effectiveStartDate: json['effective_start_date'] ?? '',
      effectiveEndDate: json['effective_end_date'],
      activeFlag: json['active_flag'] ?? '',
      createdBy: json['created_by'] ?? '',
      creationDate: json['creation_date'] ?? '',
      lastUpdatedBy: json['last_updated_by'] ?? '',
      lastUpdateDate: json['last_update_date'] ?? '',
      component: json['component'] != null ? AdjustmentComponentDto.fromJson(json['component']) : null,
    );
  }

  AdjustmentAssignmentDetail toDomain() {
    return AdjustmentAssignmentDetail(
      assignmentDetailId: assignmentDetailId,
      assignmentDetailGuid: assignmentDetailGuid,
      enterpriseId: enterpriseId,
      employeeId: employeeId,
      planId: planId,
      adjustmentId: adjustmentId,
      changeSource: changeSource,
      currencyCode: currencyCode,
      componentId: componentId,
      amount: (amount is num) ? amount.toDouble() : 0.0,
      effectiveStartDate: DateTime.tryParse(effectiveStartDate) ?? DateTime.now(),
      effectiveEndDate: effectiveEndDate != null ? DateTime.tryParse(effectiveEndDate!) : null,
      activeFlag: activeFlag,
      createdBy: createdBy,
      creationDate: DateTime.tryParse(creationDate) ?? DateTime.now(),
      lastUpdatedBy: lastUpdatedBy,
      lastUpdateDate: DateTime.tryParse(lastUpdateDate) ?? DateTime.now(),
      component: component?.toDomain(),
    );
  }
}

class AdjustmentComponentDto {
  final int componentId;
  final String componentGuid;
  final String componentCode;
  final String componentName;
  final String? description;
  final String componentTypeCode;
  final String calculationMethodCode;
  final String? baseAmountSource;
  final String? formulaName;
  final dynamic minValue;
  final dynamic maxValue;
  final String currencyCode;
  final String effectiveStartDate;
  final String effectiveEndDate;
  final String activeFlag;
  final String createdBy;
  final String creationDate;
  final String lastUpdatedBy;
  final String lastUpdateDate;

  AdjustmentComponentDto({
    required this.componentId,
    required this.componentGuid,
    required this.componentCode,
    required this.componentName,
    this.description,
    required this.componentTypeCode,
    required this.calculationMethodCode,
    this.baseAmountSource,
    this.formulaName,
    required this.minValue,
    required this.maxValue,
    required this.currencyCode,
    required this.effectiveStartDate,
    required this.effectiveEndDate,
    required this.activeFlag,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdatedBy,
    required this.lastUpdateDate,
  });

  factory AdjustmentComponentDto.fromJson(Map<String, dynamic> json) {
    return AdjustmentComponentDto(
      componentId: json['component_id'] ?? 0,
      componentGuid: json['component_guid'] ?? '',
      componentCode: json['component_code'] ?? '',
      componentName: json['component_name'] ?? '',
      description: json['description'],
      componentTypeCode: json['component_type_code'] ?? '',
      calculationMethodCode: json['calculation_method_code'] ?? '',
      baseAmountSource: json['base_amount_source'],
      formulaName: json['formula_name'],
      minValue: json['min_value'] ?? 0,
      maxValue: json['max_value'] ?? 0,
      currencyCode: json['currency_code'] ?? '',
      effectiveStartDate: json['effective_start_date'] ?? '',
      effectiveEndDate: json['effective_end_date'] ?? '',
      activeFlag: json['active_flag'] ?? '',
      createdBy: json['created_by'] ?? '',
      creationDate: json['creation_date'] ?? '',
      lastUpdatedBy: json['last_updated_by'] ?? '',
      lastUpdateDate: json['last_update_date'] ?? '',
    );
  }

  AdjustmentComponent toDomain() {
    return AdjustmentComponent(
      componentId: componentId,
      componentGuid: componentGuid,
      componentCode: componentCode,
      componentName: componentName,
      description: description,
      componentTypeCode: componentTypeCode,
      calculationMethodCode: calculationMethodCode,
      baseAmountSource: baseAmountSource,
      formulaName: formulaName,
      minValue: (minValue is num) ? minValue.toDouble() : 0.0,
      maxValue: (maxValue is num) ? maxValue.toDouble() : 0.0,
      currencyCode: currencyCode,
      effectiveStartDate: DateTime.tryParse(effectiveStartDate) ?? DateTime.now(),
      effectiveEndDate: DateTime.tryParse(effectiveEndDate) ?? DateTime.now(),
      activeFlag: activeFlag,
      createdBy: createdBy,
      creationDate: DateTime.tryParse(creationDate) ?? DateTime.now(),
      lastUpdatedBy: lastUpdatedBy,
      lastUpdateDate: DateTime.tryParse(lastUpdateDate) ?? DateTime.now(),
    );
  }
}

class PaginationDto {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  PaginationDto({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  factory PaginationDto.fromJson(Map<String, dynamic> json) {
    return PaginationDto(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      totalPages: json['total_pages'] ?? 1,
      hasNext: json['has_next'] ?? false,
      hasPrevious: json['has_previous'] ?? false,
    );
  }
}
