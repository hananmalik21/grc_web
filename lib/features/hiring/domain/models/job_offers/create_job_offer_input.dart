class CreateJobOfferComponentInput {
  const CreateJobOfferComponentInput({
    required this.planId,
    required this.componentId,
    required this.amount,
    required this.currencyCode,
    required this.frequencyCode,
  });

  final int planId;
  final int componentId;
  final double amount;
  final String currencyCode;
  final String frequencyCode;

  Map<String, dynamic> toJson() => {
    'plan_id': planId,
    'component_id': componentId,
    'amount': amount,
    'currency_code': currencyCode,
    'frequency_code': frequencyCode,
  };
}

class CreateJobOfferBenefitsInput {
  const CreateJobOfferBenefitsInput({
    required this.healthInsurance,
    required this.dentalInsurance,
    required this.visionInsurance,
    required this.lifeInsurance,
    required this.retirementPlan,
    required this.ptoDays,
    required this.sickDays,
    required this.personalDays,
    required this.parentalLeave,
    required this.additionalBenefits,
  });

  final String healthInsurance;
  final String dentalInsurance;
  final String visionInsurance;
  final String lifeInsurance;
  final String retirementPlan;
  final int ptoDays;
  final int sickDays;
  final int personalDays;
  final String parentalLeave;
  final String additionalBenefits;

  Map<String, dynamic> toJson() => {
    'health_insurance': healthInsurance,
    'dental_insurance': dentalInsurance,
    'vision_insurance': visionInsurance,
    'life_insurance': lifeInsurance,
    'retirement_plan': retirementPlan,
    'pto_days': ptoDays,
    'sick_days': sickDays,
    'personal_days': personalDays,
    'parental_leave': parentalLeave,
    'additional_benefits': additionalBenefits,
  };
}

class CreateJobOfferTermsInput {
  const CreateJobOfferTermsInput({
    required this.probationPeriod,
    required this.offerExpiryDate,
    required this.backgroundCheckRequired,
    required this.drugTestRequired,
    required this.ndaRequired,
    required this.nonCompeteRequired,
    required this.additionalTerms,
  });

  final String probationPeriod;
  final String offerExpiryDate;
  final String backgroundCheckRequired;
  final String drugTestRequired;
  final String ndaRequired;
  final String nonCompeteRequired;
  final String additionalTerms;

  Map<String, dynamic> toJson() => {
    'probation_period': probationPeriod,
    'offer_expiry_date': offerExpiryDate,
    'background_check_required': backgroundCheckRequired,
    'drug_test_required': drugTestRequired,
    'nda_required': ndaRequired,
    'non_compete_required': nonCompeteRequired,
    'additional_terms': additionalTerms,
  };
}

class CreateJobOfferInput {
  const CreateJobOfferInput({
    required this.enterpriseId,
    required this.applicationGuid,
    required this.candidateGuid,
    required this.postingId,
    required this.jobTitle,
    required this.positionId,
    required this.departmentId,
    required this.location,
    required this.workModeCode,
    required this.employmentTypeCode,
    required this.gradeId,
    required this.reportingManagerId,
    required this.startDate,
    required this.comments,
    required this.components,
    required this.benefits,
    required this.terms,
    required this.createdBy,
  });

  final int enterpriseId;
  final String applicationGuid;
  final String candidateGuid;
  final int postingId;
  final String jobTitle;
  final String positionId;
  final String departmentId;
  final String location;
  final String workModeCode;
  final String employmentTypeCode;
  final int gradeId;
  final int reportingManagerId;
  final String startDate;
  final String comments;
  final List<CreateJobOfferComponentInput> components;
  final CreateJobOfferBenefitsInput benefits;
  final CreateJobOfferTermsInput terms;
  final String createdBy;

  Map<String, dynamic> toJson() => {
    'enterprise_id': enterpriseId,
    'application_guid': applicationGuid,
    'candidate_guid': candidateGuid,
    'posting_id': postingId,
    'job_title': jobTitle,
    'position_id': positionId,
    'department_id': departmentId,
    'location': location,
    'work_mode_code': workModeCode,
    'employment_type_code': employmentTypeCode,
    'grade_id': gradeId,
    'reporting_manager_id': reportingManagerId,
    'start_date': startDate,
    'comments': comments,
    'components': components.map((component) => component.toJson()).toList(),
    'benefits': benefits.toJson(),
    'terms': terms.toJson(),
    'created_by': createdBy,
  };
}
