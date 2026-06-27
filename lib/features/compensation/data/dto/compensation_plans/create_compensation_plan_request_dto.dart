class CreateCompensationPlanAttributeDto {
  final int enterpriseId;
  final String attributeCode;
  final String attributeValue;
  final String createdBy;

  const CreateCompensationPlanAttributeDto({
    required this.enterpriseId,
    required this.attributeCode,
    required this.attributeValue,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'enterprise_id': enterpriseId,
      'attribute_code': attributeCode,
      'attribute_value': attributeValue,
      'created_by': createdBy,
    };
  }
}

class CreateCompensationPlanBudgetDto {
  final num budgetAmount;
  final String currencyCode;
  final String createdBy;

  const CreateCompensationPlanBudgetDto({
    required this.budgetAmount,
    required this.currencyCode,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {'budget_amount': budgetAmount, 'currency_code': currencyCode, 'created_by': createdBy};
  }
}

class CreateCompensationPlanPositionDto {
  final String positionId;
  final int enterpriseId;
  final String createdBy;

  const CreateCompensationPlanPositionDto({
    required this.positionId,
    required this.enterpriseId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {'position_id': positionId, 'enterprise_id': enterpriseId, 'created_by': createdBy};
  }
}

class CreateCompensationPlanBusinessUnitDto {
  final int enterpriseId;
  final String orgUnitId;
  final String createdBy;

  const CreateCompensationPlanBusinessUnitDto({
    required this.enterpriseId,
    required this.orgUnitId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {'enterprise_id': enterpriseId, 'org_unit_id': orgUnitId, 'created_by': createdBy};
  }
}

class CreateCompensationPlanComponentDto {
  final int componentId;
  final int displaySequence;
  final String mandatoryFlag;
  final String activeFlag;
  final String? frequencyCode;
  final String? payBasisCode;
  final String proratedFlag;
  final String taxableFlag;
  final String pensionableFlag;
  final String statutoryFlag;
  final String includeInCtcFlag;
  final String recurringFlag;
  final String optionalFlag;
  final String amortizableFlag;
  final String createdBy;

  const CreateCompensationPlanComponentDto({
    required this.componentId,
    required this.displaySequence,
    required this.mandatoryFlag,
    required this.activeFlag,
    this.frequencyCode,
    this.payBasisCode,
    required this.proratedFlag,
    required this.taxableFlag,
    required this.pensionableFlag,
    required this.statutoryFlag,
    required this.includeInCtcFlag,
    required this.recurringFlag,
    required this.optionalFlag,
    required this.amortizableFlag,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'component_id': componentId,
      'display_sequence': displaySequence,
      'mandatory_flag': mandatoryFlag,
      'active_flag': activeFlag,
      if (frequencyCode != null) 'frequency_code': frequencyCode,
      if (payBasisCode != null) 'pay_basis': payBasisCode,
      'prorated_flag': proratedFlag,
      'taxable_flag': taxableFlag,
      'pensionable_flag': pensionableFlag,
      'statutory_flag': statutoryFlag,
      'include_in_ctc_flag': includeInCtcFlag,
      'recurring_flag': recurringFlag,
      'optional_flag': optionalFlag,
      'amortizable_flag': amortizableFlag,
      'created_by': createdBy,
    };
  }
}

class CreateCompensationPlanEligibilityDto {
  final String allEmployeesFlag;
  final String createdBy;

  const CreateCompensationPlanEligibilityDto({required this.allEmployeesFlag, required this.createdBy});

  Map<String, dynamic> toJson() {
    return {'all_employees_flag': allEmployeesFlag, 'created_by': createdBy};
  }
}

class CreateCompensationPlanEmploymentTypeDto {
  final int enterpriseId;
  final String employmentTypeCode;
  final String createdBy;

  const CreateCompensationPlanEmploymentTypeDto({
    required this.enterpriseId,
    required this.employmentTypeCode,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {'enterprise_id': enterpriseId, 'employment_type_code': employmentTypeCode, 'created_by': createdBy};
  }
}

class CreateCompensationPlanGradeDto {
  final int gradeId;
  final String createdBy;

  const CreateCompensationPlanGradeDto({required this.gradeId, required this.createdBy});

  Map<String, dynamic> toJson() {
    return {'grade_id': gradeId, 'created_by': createdBy};
  }
}

class CreateCompensationPlanJobFamilyDto {
  final int enterpriseId;
  final int jobFamilyId;
  final String createdBy;

  const CreateCompensationPlanJobFamilyDto({
    required this.enterpriseId,
    required this.jobFamilyId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {'enterprise_id': enterpriseId, 'job_family_id': jobFamilyId, 'created_by': createdBy};
  }
}

class CreateCompensationPlanLocationDto {
  final int enterpriseId;
  final int countryId;
  final String createdBy;

  const CreateCompensationPlanLocationDto({
    required this.enterpriseId,
    required this.countryId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {'enterprise_id': enterpriseId, 'country_id': countryId, 'created_by': createdBy};
  }
}

class CreateCompensationPlanSalaryStructureDto {
  final int enterpriseId;
  final int structureId;
  final String createdBy;

  const CreateCompensationPlanSalaryStructureDto({
    required this.enterpriseId,
    required this.structureId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {'enterprise_id': enterpriseId, 'structure_id': structureId, 'created_by': createdBy};
  }
}

class CreateCompensationPlanEmployeeAssignmentDto {
  final int employeeId;
  final String employeeGuid;
  final int enterpriseId;
  final String createdBy;

  const CreateCompensationPlanEmployeeAssignmentDto({
    required this.employeeId,
    required this.employeeGuid,
    required this.enterpriseId,
    required this.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'employee_id': employeeId,
      'employee_guid': employeeGuid,
      'enterprise_id': enterpriseId,
      'created_by': createdBy,
    };
  }
}

class CreateCompensationPlanRequestDto {
  final String? planGuid;
  final int enterpriseId;
  final int countryId;
  final String planCode;
  final String planName;
  final String planTypeCode;
  final String statusCode;
  final String currencyCode;
  final String? startDate;
  final String? endDate;
  final num budgetAmount;
  final String? description;
  final int? planOwner;
  final String createdBy;
  final List<CreateCompensationPlanAttributeDto> attributes;
  final CreateCompensationPlanBudgetDto budget;
  final List<CreateCompensationPlanPositionDto> positions;
  final List<CreateCompensationPlanBusinessUnitDto> businessUnits;
  final List<CreateCompensationPlanComponentDto> components;
  final CreateCompensationPlanEligibilityDto eligibility;
  final List<CreateCompensationPlanEmploymentTypeDto> employmentTypes;
  final List<CreateCompensationPlanGradeDto> grades;
  final List<CreateCompensationPlanJobFamilyDto> jobFamilies;
  final List<CreateCompensationPlanLocationDto> locations;
  final List<CreateCompensationPlanSalaryStructureDto> salaryStructures;
  final List<CreateCompensationPlanEmployeeAssignmentDto> employeeAssignments;

  const CreateCompensationPlanRequestDto({
    this.planGuid,
    required this.enterpriseId,
    required this.countryId,
    required this.planCode,
    required this.planName,
    required this.planTypeCode,
    required this.statusCode,
    required this.currencyCode,
    this.startDate,
    this.endDate,
    required this.budgetAmount,
    required this.description,
    this.planOwner,
    required this.createdBy,
    required this.attributes,
    required this.budget,
    required this.positions,
    required this.businessUnits,
    required this.components,
    required this.eligibility,
    required this.employmentTypes,
    required this.grades,
    required this.jobFamilies,
    required this.locations,
    required this.salaryStructures,
    required this.employeeAssignments,
  });

  Map<String, dynamic> toJson() {
    return {
      if (planGuid != null) 'plan_guid': planGuid,
      'enterprise_id': enterpriseId,
      'country_id': countryId,
      'plan_code': planCode,
      'plan_name': planName,
      'plan_type_code': planTypeCode,
      'status_code': statusCode,
      'currency_code': currencyCode,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      'budget_amount': budgetAmount,
      'description': description,
      if (planOwner != null) 'plan_owner': planOwner,
      'created_by': createdBy,
      'attributes': attributes.map((e) => e.toJson()).toList(),
      'budget': budget.toJson(),
      'positions': positions.map((e) => e.toJson()).toList(),
      'business_units': businessUnits.map((e) => e.toJson()).toList(),
      'components': components.map((e) => e.toJson()).toList(),
      'eligibility': eligibility.toJson(),
      'employment_types': employmentTypes.map((e) => e.toJson()).toList(),
      'grades': grades.map((e) => e.toJson()).toList(),
      'job_families': jobFamilies.map((e) => e.toJson()).toList(),
      'locations': locations.map((e) => e.toJson()).toList(),
      'salary_structures': salaryStructures.map((e) => e.toJson()).toList(),
      'employee_assignments': employeeAssignments.map((e) => e.toJson()).toList(),
    };
  }
}
