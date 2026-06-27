import 'package:grc/features/employee_management/domain/models/employee_full_details.dart';

class EmployeeFullDetailsResponseDto {
  EmployeeFullDetailsResponseDto({required this.data});

  factory EmployeeFullDetailsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>?;
    return EmployeeFullDetailsResponseDto(data: data != null ? EmployeeFullDetailsDataDto.fromJson(data) : null);
  }

  final EmployeeFullDetailsDataDto? data;

  EmployeeFullDetails? toDomain() => data?.toDomain();
}

class EmployeeFullDetailsDataDto {
  EmployeeFullDetailsDataDto({
    this.employee,
    this.assignment,
    this.demographics,
    this.workSchedule,
    this.compensation,
    this.allowances,
    this.documentCompliance,
    this.documents = const [],
    this.emergencyContacts = const [],
    this.bankAccounts = const [],
    this.addresses = const [],
    this.workSchedules = const [],
    this.compensationHistory = const [],
    this.allowancesHistory = const [],
    this.documentComplianceHistory = const [],
  });

  factory EmployeeFullDetailsDataDto.fromJson(Map<String, dynamic> json) {
    return EmployeeFullDetailsDataDto(
      employee: _parseMap(json['employee'], EmployeeDetailSectionDto.fromJson),
      assignment: _parseMap(json['assignment'], AssignmentDetailSectionDto.fromJson),
      demographics: _parseMap(json['demographics'], DemographicsDetailSectionDto.fromJson),
      workSchedule: _parseMap(json['work_schedule'], WorkScheduleDetailSectionDto.fromJson),
      compensation: _parseMap(json['compensation'], CompensationDetailSectionDto.fromJson),
      allowances: _parseMap(json['allowances'], AllowancesDetailSectionDto.fromJson),
      documentCompliance: _parseMap(json['document_compliance'], DocumentComplianceDetailSectionDto.fromJson),
      documents: _parseList(json['documents'], DocumentItemDto.fromJson),
      emergencyContacts: _parseList(json['emergency_contacts'], EmergencyContactItemDto.fromJson),
      bankAccounts: _parseList(json['bank_accounts'], BankAccountItemDto.fromJson),
      addresses: _parseList(json['addresses'], AddressItemDto.fromJson),
      workSchedules: _parseList(json['work_schedules'], WorkScheduleHistoryItemDto.fromJson),
      compensationHistory: _parseList(json['compensation_history'], CompensationHistoryItemDto.fromJson),
      allowancesHistory: _parseList(json['allowances_history'], AllowancesHistoryItemDto.fromJson),
      documentComplianceHistory: _parseList(
        json['document_compliance_history'],
        DocumentComplianceHistoryItemDto.fromJson,
      ),
    );
  }

  static T? _parseMap<T>(dynamic v, T Function(Map<String, dynamic>) fromJson) {
    if (v is! Map<String, dynamic>) return null;
    return fromJson(v);
  }

  static List<T> _parseList<T>(dynamic v, T Function(Map<String, dynamic>) fromJson) {
    if (v is! List) return [];
    return v.whereType<Map<String, dynamic>>().map(fromJson).toList();
  }

  static int? _optionalInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v);
    return null;
  }

  static String? _optionalString(dynamic value) {
    if (value == null || value == 'null') return null;
    if (value is String) return value.trim().isEmpty ? null : value.trim();
    return value.toString().trim();
  }

  final EmployeeDetailSectionDto? employee;
  final AssignmentDetailSectionDto? assignment;
  final DemographicsDetailSectionDto? demographics;
  final WorkScheduleDetailSectionDto? workSchedule;
  final CompensationDetailSectionDto? compensation;
  final AllowancesDetailSectionDto? allowances;
  final DocumentComplianceDetailSectionDto? documentCompliance;
  final List<DocumentItemDto> documents;
  final List<EmergencyContactItemDto> emergencyContacts;
  final List<BankAccountItemDto> bankAccounts;
  final List<AddressItemDto> addresses;
  final List<WorkScheduleHistoryItemDto> workSchedules;
  final List<CompensationHistoryItemDto> compensationHistory;
  final List<AllowancesHistoryItemDto> allowancesHistory;
  final List<DocumentComplianceHistoryItemDto> documentComplianceHistory;

  EmployeeFullDetails? toDomain() {
    if (employee == null || assignment == null) return null;
    return EmployeeFullDetails(
      employee: employee!.toDomain(),
      assignment: assignment!.toDomain(),
      demographics: demographics?.toDomain(),
      workSchedule: workSchedule?.toDomain(),
      compensation: compensation?.toDomain(),
      allowances: allowances?.toDomain(),
      documentCompliance: documentCompliance?.toDomain(),
      documents: documents.map((e) => e.toDomain()).toList(),
      emergencyContacts: emergencyContacts.map((e) => e.toDomain()).toList(),
      bankAccounts: bankAccounts.map((e) => e.toDomain()).toList(),
      addresses: addresses.map((e) => e.toDomain()).toList(),
      workSchedules: workSchedules.map((e) => e.toDomain()).toList(),
      compensationHistory: compensationHistory.map((e) => e.toDomain()).toList(),
      allowancesHistory: allowancesHistory.map((e) => e.toDomain()).toList(),
      documentComplianceHistory: documentComplianceHistory.map((e) => e.toDomain()).toList(),
    );
  }
}

class EmployeeDetailSectionDto {
  EmployeeDetailSectionDto({
    required this.enterpriseId,
    required this.employeeId,
    required this.employeeGuid,
    this.firstNameEn,
    this.middleNameEn,
    this.lastNameEn,
    this.fourthNameEn,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    this.fourthNameAr,
    this.familyNameAr,
    this.email,
    this.phoneNumber,
    this.mobileNumber,
    this.dateOfBirth,
    this.employeeStatus,
    this.employeeIsActive,
    this.employeeNumber,
    this.workLocationId,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.probationDays,
    this.reportingToEmpId,
    this.creationDate,
    this.lastUpdateDate,
  });

  factory EmployeeDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailSectionDto(
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: EmployeeFullDetailsDataDto._optionalString(json['employee_guid']) ?? '',
      firstNameEn: EmployeeFullDetailsDataDto._optionalString(json['first_name_en']),
      middleNameEn: EmployeeFullDetailsDataDto._optionalString(json['middle_name_en']),
      lastNameEn: EmployeeFullDetailsDataDto._optionalString(json['last_name_en']),
      fourthNameEn: EmployeeFullDetailsDataDto._optionalString(json['fourth_name_en']),
      firstNameAr: EmployeeFullDetailsDataDto._optionalString(json['first_name_ar']),
      middleNameAr: EmployeeFullDetailsDataDto._optionalString(json['middle_name_ar']),
      lastNameAr: EmployeeFullDetailsDataDto._optionalString(json['last_name_ar']),
      fourthNameAr: EmployeeFullDetailsDataDto._optionalString(json['fourth_name_ar']),
      familyNameAr: EmployeeFullDetailsDataDto._optionalString(json['family_name_ar']),
      email: EmployeeFullDetailsDataDto._optionalString(json['email']),
      phoneNumber: EmployeeFullDetailsDataDto._optionalString(json['phone_number']),
      mobileNumber: EmployeeFullDetailsDataDto._optionalString(json['mobile_number']),
      dateOfBirth: EmployeeFullDetailsDataDto._optionalString(json['date_of_birth']),
      employeeStatus: EmployeeFullDetailsDataDto._optionalString(json['employee_status']),
      employeeIsActive: EmployeeFullDetailsDataDto._optionalString(json['employee_is_active']),
      employeeNumber: EmployeeFullDetailsDataDto._optionalString(json['employee_number']),
      workLocationId: EmployeeFullDetailsDataDto._optionalInt(json['work_location_id']),
      jobFamilyId: EmployeeFullDetailsDataDto._optionalInt(json['job_family_id']),
      jobLevelId: EmployeeFullDetailsDataDto._optionalInt(json['job_level_id']),
      gradeId: EmployeeFullDetailsDataDto._optionalInt(json['grade_id']),
      probationDays: EmployeeFullDetailsDataDto._optionalInt(json['probation_days']),
      reportingToEmpId: EmployeeFullDetailsDataDto._optionalInt(json['reporting_to_emp_id']),
      creationDate: EmployeeFullDetailsDataDto._optionalString(json['creation_date']),
      lastUpdateDate: EmployeeFullDetailsDataDto._optionalString(json['last_update_date']),
    );
  }

  final int enterpriseId;
  final int employeeId;
  final String employeeGuid;
  final String? firstNameEn;
  final String? middleNameEn;
  final String? lastNameEn;
  final String? fourthNameEn;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String? fourthNameAr;
  final String? familyNameAr;
  final String? email;
  final String? phoneNumber;
  final String? mobileNumber;
  final String? dateOfBirth;
  final String? employeeStatus;
  final String? employeeIsActive;
  final String? employeeNumber;
  final int? workLocationId;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final int? probationDays;
  final int? reportingToEmpId;
  final String? creationDate;
  final String? lastUpdateDate;

  EmployeeDetailSection toDomain() => EmployeeDetailSection(
    enterpriseId: enterpriseId,
    employeeId: employeeId,
    employeeGuid: employeeGuid,
    firstNameEn: firstNameEn,
    middleNameEn: middleNameEn,
    lastNameEn: lastNameEn,
    fourthNameEn: fourthNameEn,
    firstNameAr: firstNameAr,
    middleNameAr: middleNameAr,
    lastNameAr: lastNameAr,
    fourthNameAr: fourthNameAr,
    familyNameAr: familyNameAr,
    email: email,
    phoneNumber: phoneNumber,
    mobileNumber: mobileNumber,
    dateOfBirth: dateOfBirth,
    employeeStatus: employeeStatus,
    employeeIsActive: employeeIsActive,
    employeeNumber: employeeNumber,
    workLocationId: workLocationId,
    jobFamilyId: jobFamilyId,
    jobLevelId: jobLevelId,
    gradeId: gradeId,
    probationDays: probationDays,
    reportingToEmpId: reportingToEmpId,
    creationDate: creationDate,
    lastUpdateDate: lastUpdateDate,
  );
}

class AssignmentPositionDto {
  AssignmentPositionDto({
    this.positionId,
    this.positionCode,
    this.positionNameEn,
    this.positionNameAr,
    this.positionStatus,
    this.budgetedMinKd,
    this.budgetedMaxKd,
  });

  factory AssignmentPositionDto.fromJson(Map<String, dynamic> json) {
    return AssignmentPositionDto(
      positionId: json['position_id'] as String?,
      positionCode: json['position_code'] as String?,
      positionNameEn: (json['position_name_en'] ?? json['position_title_en']) as String?,
      positionNameAr: (json['position_name_ar'] ?? json['position_title_ar']) as String?,
      positionStatus: (json['position_status'] ?? json['status']) as String?,
      budgetedMinKd: (json['budgeted_min_kd'] as num?)?.toDouble(),
      budgetedMaxKd: (json['budgeted_max_kd'] as num?)?.toDouble(),
    );
  }

  final String? positionId;
  final String? positionCode;
  final String? positionNameEn;
  final String? positionNameAr;
  final String? positionStatus;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;
}

class AssignmentJobFamilyDto {
  AssignmentJobFamilyDto({
    this.jobFamilyId,
    this.jobFamilyCode,
    this.jobFamilyNameEn,
    this.jobFamilyNameAr,
    this.jobFamilyStatus,
  });

  factory AssignmentJobFamilyDto.fromJson(Map<String, dynamic> json) {
    return AssignmentJobFamilyDto(
      jobFamilyId: (json['job_family_id'] as num?)?.toInt(),
      jobFamilyCode: json['job_family_code'] as String?,
      jobFamilyNameEn: json['job_family_name_en'] as String?,
      jobFamilyNameAr: json['job_family_name_ar'] as String?,
      jobFamilyStatus: json['job_family_status'] as String?,
    );
  }

  final int? jobFamilyId;
  final String? jobFamilyCode;
  final String? jobFamilyNameEn;
  final String? jobFamilyNameAr;
  final String? jobFamilyStatus;
}

class AssignmentJobLevelDto {
  AssignmentJobLevelDto({
    this.jobLevelId,
    this.jobLevelCode,
    this.jobLevelNameEn,
    this.minGradeId,
    this.maxGradeId,
    this.jobLevelStatus,
  });

  factory AssignmentJobLevelDto.fromJson(Map<String, dynamic> json) {
    return AssignmentJobLevelDto(
      jobLevelId: (json['job_level_id'] as num?)?.toInt(),
      jobLevelCode: json['job_level_code'] as String?,
      jobLevelNameEn: json['job_level_name_en'] as String?,
      minGradeId: (json['min_grade_id'] as num?)?.toInt(),
      maxGradeId: (json['max_grade_id'] as num?)?.toInt(),
      jobLevelStatus: json['job_level_status'] as String?,
    );
  }

  final int? jobLevelId;
  final String? jobLevelCode;
  final String? jobLevelNameEn;
  final int? minGradeId;
  final int? maxGradeId;
  final String? jobLevelStatus;
}

class AssignmentGradeDto {
  AssignmentGradeDto({
    this.gradeId,
    this.gradeNumber,
    this.gradeCategory,
    this.currencyCode,
    this.step1Salary,
    this.step2Salary,
    this.step3Salary,
    this.step4Salary,
    this.step5Salary,
    this.gradeStatus,
  });

  factory AssignmentGradeDto.fromJson(Map<String, dynamic> json) {
    return AssignmentGradeDto(
      gradeId: (json['grade_id'] as num?)?.toInt(),
      gradeNumber: json['grade_number'] as String?,
      gradeCategory: json['grade_category'] as String?,
      currencyCode: json['currency_code'] as String?,
      step1Salary: (json['step_1_salary'] as num?)?.toDouble(),
      step2Salary: (json['step_2_salary'] as num?)?.toDouble(),
      step3Salary: (json['step_3_salary'] as num?)?.toDouble(),
      step4Salary: (json['step_4_salary'] as num?)?.toDouble(),
      step5Salary: (json['step_5_salary'] as num?)?.toDouble(),
      gradeStatus: json['grade_status'] as String?,
    );
  }

  final int? gradeId;
  final String? gradeNumber;
  final String? gradeCategory;
  final String? currencyCode;
  final double? step1Salary;
  final double? step2Salary;
  final double? step3Salary;
  final double? step4Salary;
  final double? step5Salary;
  final String? gradeStatus;
}

class AssignmentDetailSectionDto {
  AssignmentDetailSectionDto({
    required this.assignmentId,
    this.assignmentGuid,
    this.orgUnitId,
    this.orgStructureList = const [],
    this.positionId,
    this.position,
    this.jobFamilyId,
    this.jobLevelId,
    this.gradeId,
    this.probationDays,
    this.reportingToEmpId,
    this.workLocationId,
    this.workLocationName,
    this.employeeNumber,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.enterpriseHireDate,
    this.contractTypeCode,
    this.employmentStatus,
    this.assignmentStatus,
    this.assignmentIsActive,
    this.jobFamily,
    this.jobLevel,
    this.grade,
    this.budgetedMinKd,
    this.budgetedMaxKd,
  });

  factory AssignmentDetailSectionDto.fromJson(Map<String, dynamic> json) {
    final list = json['org_structure_list'];
    final positionJson = json['position'] as Map<String, dynamic>?;
    final jobFamilyJson = json['job_family'] as Map<String, dynamic>?;
    final jobLevelJson = json['job_level'] as Map<String, dynamic>?;
    final gradeJson = json['grade'] as Map<String, dynamic>?;
    final workLocationObjJson = json['workLocationObj'] as Map<String, dynamic>?;
    return AssignmentDetailSectionDto(
      assignmentId: (json['assignment_id'] as num?)?.toInt() ?? 0,
      assignmentGuid: json['assignment_guid'] as String?,
      orgUnitId: json['org_unit_id'] as String?,
      orgStructureList: list is List
          ? (list).whereType<Map<String, dynamic>>().map(OrgStructureItemDto.fromJson).toList()
          : const [],
      positionId: json['position_id'] as String?,
      position: positionJson != null ? AssignmentPositionDto.fromJson(positionJson) : null,
      jobFamilyId: EmployeeFullDetailsDataDto._optionalInt(json['job_family_id']),
      jobLevelId: EmployeeFullDetailsDataDto._optionalInt(json['job_level_id']),
      gradeId: EmployeeFullDetailsDataDto._optionalInt(json['grade_id']),
      probationDays: EmployeeFullDetailsDataDto._optionalInt(json['probation_days']),
      reportingToEmpId: EmployeeFullDetailsDataDto._optionalInt(json['reporting_to_emp_id']),
      workLocationId: EmployeeFullDetailsDataDto._optionalInt(json['work_location_id']),
      workLocationName: workLocationObjJson != null ? workLocationObjJson['meaning_en'] as String? : null,
      employeeNumber: json['employee_number'] as String?,
      effectiveStartDate: json['effective_start_date'] as String?,
      effectiveEndDate: json['effective_end_date'] as String?,
      enterpriseHireDate: json['enterprise_hire_date'] as String?,
      contractTypeCode: json['contract_type_code'] as String?,
      employmentStatus: json['employment_status'] as String?,
      assignmentStatus: json['assignment_status'] as String?,
      assignmentIsActive: json['assignment_is_active'] as String?,
      jobFamily: jobFamilyJson != null ? AssignmentJobFamilyDto.fromJson(jobFamilyJson) : null,
      jobLevel: jobLevelJson != null ? AssignmentJobLevelDto.fromJson(jobLevelJson) : null,
      grade: gradeJson != null ? AssignmentGradeDto.fromJson(gradeJson) : null,
      budgetedMinKd: (json['budgeted_min_kd'] as num?)?.toDouble(),
      budgetedMaxKd: (json['budgeted_max_kd'] as num?)?.toDouble(),
    );
  }

  final int assignmentId;
  final String? assignmentGuid;
  final String? orgUnitId;
  final List<OrgStructureItemDto> orgStructureList;
  final String? positionId;
  final AssignmentPositionDto? position;
  final int? jobFamilyId;
  final int? jobLevelId;
  final int? gradeId;
  final int? probationDays;
  final int? reportingToEmpId;
  final int? workLocationId;
  final String? workLocationName;
  final String? employeeNumber;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? enterpriseHireDate;
  final String? contractTypeCode;
  final String? employmentStatus;
  final String? assignmentStatus;
  final String? assignmentIsActive;
  final AssignmentJobFamilyDto? jobFamily;
  final AssignmentJobLevelDto? jobLevel;
  final AssignmentGradeDto? grade;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;

  AssignmentDetailSection toDomain() => AssignmentDetailSection(
    assignmentId: assignmentId,
    assignmentGuid: assignmentGuid,
    orgUnitId: orgUnitId,
    orgStructureList: orgStructureList.map((e) => e.toDomain()).toList(),
    positionId: positionId,
    positionNameEn: position?.positionNameEn,
    positionCode: position?.positionCode,
    jobFamilyId: jobFamilyId,
    jobLevelId: jobLevelId,
    gradeId: gradeId,
    probationDays: probationDays,
    reportingToEmpId: reportingToEmpId,
    workLocationId: workLocationId,
    workLocationName: workLocationName,
    employeeNumber: employeeNumber,
    effectiveStartDate: effectiveStartDate,
    effectiveEndDate: effectiveEndDate,
    enterpriseHireDate: enterpriseHireDate,
    contractTypeCode: contractTypeCode,
    employmentStatus: employmentStatus,
    assignmentStatus: assignmentStatus,
    assignmentIsActive: assignmentIsActive,
    budgetedMinKd: budgetedMinKd,
    budgetedMaxKd: budgetedMaxKd,
    position: position != null
        ? AssignmentPositionInfo(
            positionId: position!.positionId ?? '',
            positionCode: position!.positionCode ?? '',
            positionNameEn: position!.positionNameEn ?? '',
            positionNameAr: position!.positionNameAr ?? '',
            budgetedMinKd: position!.budgetedMinKd,
            budgetedMaxKd: position!.budgetedMaxKd,
          )
        : null,
    jobFamily: jobFamily != null
        ? AssignmentJobFamilyInfo(
            jobFamilyId: jobFamily!.jobFamilyId ?? 0,
            jobFamilyCode: jobFamily!.jobFamilyCode ?? '',
            jobFamilyNameEn: jobFamily!.jobFamilyNameEn ?? '',
            jobFamilyNameAr: jobFamily!.jobFamilyNameAr ?? '',
          )
        : null,
    jobLevel: jobLevel != null
        ? AssignmentJobLevelInfo(
            jobLevelId: jobLevel!.jobLevelId ?? 0,
            jobLevelCode: jobLevel!.jobLevelCode ?? '',
            jobLevelNameEn: jobLevel!.jobLevelNameEn ?? '',
            minGradeId: jobLevel!.minGradeId ?? 0,
            maxGradeId: jobLevel!.maxGradeId ?? 0,
          )
        : null,
    grade: grade != null
        ? AssignmentGradeInfo(
            gradeId: grade!.gradeId ?? 0,
            gradeNumber: grade!.gradeNumber ?? '',
            gradeCategory: grade!.gradeCategory ?? '',
            currencyCode: grade!.currencyCode ?? '',
            step1Salary: grade!.step1Salary ?? 0,
            step2Salary: grade!.step2Salary ?? 0,
            step3Salary: grade!.step3Salary ?? 0,
            step4Salary: grade!.step4Salary ?? 0,
            step5Salary: grade!.step5Salary ?? 0,
            gradeStatus: grade!.gradeStatus ?? '',
          )
        : null,
  );
}

class OrgStructureItemDto {
  OrgStructureItemDto({
    required this.level,
    required this.orgUnitId,
    this.orgUnitCode,
    this.orgUnitNameEn,
    this.orgUnitNameAr,
    this.levelCode,
    this.status,
    this.isActive,
  });

  factory OrgStructureItemDto.fromJson(Map<String, dynamic> json) {
    return OrgStructureItemDto(
      level: (json['level'] as num?)?.toInt() ?? 0,
      orgUnitId: json['org_unit_id'] as String? ?? '',
      orgUnitCode: json['org_unit_code'] as String?,
      orgUnitNameEn: json['org_unit_name_en'] as String?,
      orgUnitNameAr: json['org_unit_name_ar'] as String?,
      levelCode: json['level_code'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int level;
  final String orgUnitId;
  final String? orgUnitCode;
  final String? orgUnitNameEn;
  final String? orgUnitNameAr;
  final String? levelCode;
  final String? status;
  final String? isActive;

  OrgStructureItem toDomain() => OrgStructureItem(
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

class DemographicsDetailSectionDto {
  DemographicsDetailSectionDto({
    this.demoId,
    this.demoGuid,
    this.genderCode,
    this.nationalityCode,
    this.maritalStatusCode,
    this.religionCode,
    this.civilIdNumber,
    this.passportNumber,
    this.visaNumber,
    this.visaExpiry,
    this.workPermitNumber,
    this.workPermitExpiry,
  });

  factory DemographicsDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return DemographicsDetailSectionDto(
      demoId: (json['demo_id'] as num?)?.toInt(),
      demoGuid: json['demo_guid'] as String?,
      genderCode: json['gender_code'] as String?,
      nationalityCode: json['nationality_code'] as String?,
      maritalStatusCode: json['marital_status_code'] as String?,
      religionCode: json['religion_code'] as String?,
      civilIdNumber: json['civil_id_number'] as String?,
      passportNumber: json['passport_number'] as String?,
      visaNumber: json['visa_number'] as String?,
      visaExpiry: json['visa_expiry'] as String?,
      workPermitNumber: json['work_permit_number'] as String?,
      workPermitExpiry: json['work_permit_expiry'] as String?,
    );
  }

  final int? demoId;
  final String? demoGuid;
  final String? genderCode;
  final String? nationalityCode;
  final String? maritalStatusCode;
  final String? religionCode;
  final String? civilIdNumber;
  final String? passportNumber;
  final String? visaNumber;
  final String? visaExpiry;
  final String? workPermitNumber;
  final String? workPermitExpiry;

  DemographicsDetailSection toDomain() => DemographicsDetailSection(
    demoId: demoId,
    demoGuid: demoGuid,
    genderCode: genderCode,
    nationalityCode: nationalityCode,
    maritalStatusCode: maritalStatusCode,
    religionCode: religionCode,
    civilIdNumber: civilIdNumber,
    passportNumber: passportNumber,
    visaNumber: visaNumber,
    visaExpiry: visaExpiry,
    workPermitNumber: workPermitNumber,
    workPermitExpiry: workPermitExpiry,
  );
}

class WorkScheduleDetailSectionDto {
  WorkScheduleDetailSectionDto({
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.empSchId,
    this.empSchGuid,
    this.workScheduleId,
    this.wsStart,
    this.wsEnd,
    this.wsStatus,
    this.wsIsActive,
  });

  factory WorkScheduleDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return WorkScheduleDetailSectionDto(
      effectiveStartDate: json['effective_start_date'] as String?,
      effectiveEndDate: json['effective_end_date'] as String?,
      empSchId: EmployeeFullDetailsDataDto._optionalInt(json['emp_sch_id']),
      empSchGuid: json['emp_sch_guid'] as String?,
      workScheduleId: EmployeeFullDetailsDataDto._optionalInt(json['work_schedule_id']),
      wsStart: json['ws_start'] as String?,
      wsEnd: json['ws_end'] as String?,
      wsStatus: json['ws_status'] as String?,
      wsIsActive: json['ws_is_active'] as String?,
    );
  }

  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final int? empSchId;
  final String? empSchGuid;
  final int? workScheduleId;
  final String? wsStart;
  final String? wsEnd;
  final String? wsStatus;
  final String? wsIsActive;

  WorkScheduleDetailSection toDomain() => WorkScheduleDetailSection(
    effectiveStartDate: effectiveStartDate,
    effectiveEndDate: effectiveEndDate,
    empSchId: empSchId,
    empSchGuid: empSchGuid,
    workScheduleId: workScheduleId,
    wsStart: wsStart,
    wsEnd: wsEnd,
    wsStatus: wsStatus,
    wsIsActive: wsIsActive,
  );
}

class CompensationDetailSectionDto {
  CompensationDetailSectionDto({
    this.compId,
    this.compGuid,
    this.basicSalaryKwd,
    this.compStart,
    this.compEnd,
    this.compStatus,
    this.compIsActive,
  });

  factory CompensationDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return CompensationDetailSectionDto(
      compId: (json['comp_id'] as num?)?.toInt(),
      compGuid: json['comp_guid'] as String?,
      basicSalaryKwd: (json['basic_salary_kwd'] as num?)?.toDouble(),
      compStart: json['comp_start'] as String?,
      compEnd: json['comp_end'] as String?,
      compStatus: json['comp_status'] as String?,
      compIsActive: json['comp_is_active'] as String?,
    );
  }

  final int? compId;
  final String? compGuid;
  final double? basicSalaryKwd;
  final String? compStart;
  final String? compEnd;
  final String? compStatus;
  final String? compIsActive;

  CompensationDetailSection toDomain() => CompensationDetailSection(
    compId: compId,
    compGuid: compGuid,
    basicSalaryKwd: basicSalaryKwd,
    compStart: compStart,
    compEnd: compEnd,
    compStatus: compStatus,
    compIsActive: compIsActive,
  );
}

class AllowancesDetailSectionDto {
  AllowancesDetailSectionDto({
    this.allowId,
    this.allowGuid,
    this.housingKwd,
    this.transportKwd,
    this.foodKwd,
    this.mobileKwd,
    this.otherKwd,
    this.allowStart,
    this.allowEnd,
    this.allowStatus,
    this.allowIsActive,
  });

  factory AllowancesDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return AllowancesDetailSectionDto(
      allowId: (json['allow_id'] as num?)?.toInt(),
      allowGuid: json['allow_guid'] as String?,
      housingKwd: (json['housing_kwd'] as num?)?.toDouble(),
      transportKwd: (json['transport_kwd'] as num?)?.toDouble(),
      foodKwd: (json['food_kwd'] as num?)?.toDouble(),
      mobileKwd: (json['mobile_kwd'] as num?)?.toDouble(),
      otherKwd: (json['other_kwd'] as num?)?.toDouble(),
      allowStart: json['allow_start'] as String?,
      allowEnd: json['allow_end'] as String?,
      allowStatus: json['allow_status'] as String?,
      allowIsActive: json['allow_is_active'] as String?,
    );
  }

  final int? allowId;
  final String? allowGuid;
  final double? housingKwd;
  final double? transportKwd;
  final double? foodKwd;
  final double? mobileKwd;
  final double? otherKwd;
  final String? allowStart;
  final String? allowEnd;
  final String? allowStatus;
  final String? allowIsActive;

  AllowancesDetailSection toDomain() => AllowancesDetailSection(
    allowId: allowId,
    allowGuid: allowGuid,
    housingKwd: housingKwd,
    transportKwd: transportKwd,
    foodKwd: foodKwd,
    mobileKwd: mobileKwd,
    otherKwd: otherKwd,
    allowStart: allowStart,
    allowEnd: allowEnd,
    allowStatus: allowStatus,
    allowIsActive: allowIsActive,
  );
}

class DocumentComplianceDetailSectionDto {
  DocumentComplianceDetailSectionDto({
    this.docCompId,
    this.docCompGuid,
    this.civilIdExpiry,
    this.passportExpiry,
    this.doccStatus,
    this.doccIsActive,
  });

  factory DocumentComplianceDetailSectionDto.fromJson(Map<String, dynamic> json) {
    return DocumentComplianceDetailSectionDto(
      docCompId: (json['doc_comp_id'] as num?)?.toInt(),
      docCompGuid: json['doc_comp_guid'] as String?,
      civilIdExpiry: json['civil_id_expiry'] as String?,
      passportExpiry: json['passport_expiry'] as String?,
      doccStatus: json['docc_status'] as String?,
      doccIsActive: json['docc_is_active'] as String?,
    );
  }

  final int? docCompId;
  final String? docCompGuid;
  final String? civilIdExpiry;
  final String? passportExpiry;
  final String? doccStatus;
  final String? doccIsActive;

  DocumentComplianceDetailSection toDomain() => DocumentComplianceDetailSection(
    docCompId: docCompId,
    docCompGuid: docCompGuid,
    civilIdExpiry: civilIdExpiry,
    passportExpiry: passportExpiry,
    doccStatus: doccStatus,
    doccIsActive: doccIsActive,
  );
}

class DocumentItemDto {
  DocumentItemDto({
    required this.documentId,
    this.documentGuid,
    this.documentTypeCode,
    this.fileName,
    this.mimeType,
    this.fileSizeBytes,
    this.status,
    this.isActive,
    this.accessUrl,
    this.downloadUrl,
    this.fileHashSha256,
    this.creationDate,
    this.lastUpdateDate,
  });

  factory DocumentItemDto.fromJson(Map<String, dynamic> json) {
    return DocumentItemDto(
      documentId: (json['document_id'] as num?)?.toInt() ?? 0,
      documentGuid: json['document_guid'] as String?,
      documentTypeCode: json['document_type_code'] as String?,
      fileName: json['file_name'] as String?,
      mimeType: json['mime_type'] as String?,
      fileSizeBytes: (json['file_size_bytes'] as num?)?.toInt(),
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
      accessUrl: json['access_url'] as String?,
      downloadUrl: json['download_url'] as String?,
      fileHashSha256: json['file_hash_sha256'] as String?,
      creationDate: json['creation_date'] as String?,
      lastUpdateDate: json['last_update_date'] as String?,
    );
  }

  final int documentId;
  final String? documentGuid;
  final String? documentTypeCode;
  final String? fileName;
  final String? mimeType;
  final int? fileSizeBytes;
  final String? status;
  final String? isActive;
  final String? accessUrl;
  final String? downloadUrl;
  final String? fileHashSha256;
  final String? creationDate;
  final String? lastUpdateDate;

  DocumentItem toDomain() => DocumentItem(
    documentId: documentId,
    documentGuid: documentGuid,
    documentTypeCode: documentTypeCode,
    fileName: fileName,
    mimeType: mimeType,
    fileSizeBytes: fileSizeBytes,
    status: status,
    isActive: isActive,
    accessUrl: accessUrl,
    downloadUrl: downloadUrl,
    fileHashSha256: fileHashSha256,
    creationDate: creationDate,
    lastUpdateDate: lastUpdateDate,
  );
}

class EmergencyContactItemDto {
  EmergencyContactItemDto({
    required this.emergId,
    this.emergGuid,
    this.contactName,
    this.relationshipCode,
    this.phoneNumber,
    this.email,
    this.address,
    this.status,
    this.isActive,
  });

  factory EmergencyContactItemDto.fromJson(Map<String, dynamic> json) {
    return EmergencyContactItemDto(
      emergId: (json['emerg_id'] as num?)?.toInt() ?? 0,
      emergGuid: json['emerg_guid'] as String?,
      contactName: json['contact_name'] as String?,
      relationshipCode: json['relationship_code'] as String?,
      phoneNumber: json['phone_number'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int emergId;
  final String? emergGuid;
  final String? contactName;
  final String? relationshipCode;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? status;
  final String? isActive;

  EmergencyContactItem toDomain() => EmergencyContactItem(
    emergId: emergId,
    emergGuid: emergGuid,
    contactName: contactName,
    relationshipCode: relationshipCode,
    phoneNumber: phoneNumber,
    email: email,
    address: address,
    status: status,
    isActive: isActive,
  );
}

class BankAccountItemDto {
  BankAccountItemDto({
    required this.bankId,
    this.bankGuid,
    this.bankCode,
    this.bankName,
    this.accountNumber,
    this.iban,
    this.isPrimary,
    this.status,
    this.isActive,
    this.creationDate,
    this.lastUpdateDate,
  });

  factory BankAccountItemDto.fromJson(Map<String, dynamic> json) {
    return BankAccountItemDto(
      bankId: (json['bank_id'] as num?)?.toInt() ?? 0,
      bankGuid: json['bank_guid'] as String?,
      bankCode: json['bank_code'] as String?,
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
      iban: json['iban'] as String?,
      isPrimary: json['is_primary'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
      creationDate: json['creation_date'] as String?,
      lastUpdateDate: json['last_update_date'] as String?,
    );
  }

  final int bankId;
  final String? bankGuid;
  final String? bankCode;
  final String? bankName;
  final String? accountNumber;
  final String? iban;
  final String? isPrimary;
  final String? status;
  final String? isActive;
  final String? creationDate;
  final String? lastUpdateDate;

  BankAccountItem toDomain() => BankAccountItem(
    bankId: bankId,
    bankGuid: bankGuid,
    bankCode: bankCode,
    bankName: bankName,
    accountNumber: accountNumber,
    iban: iban,
    isPrimary: isPrimary,
    status: status,
    isActive: isActive,
    creationDate: creationDate,
    lastUpdateDate: lastUpdateDate,
  );
}

class AddressItemDto {
  AddressItemDto({
    required this.addressId,
    this.addressGuid,
    this.addressLine1,
    this.addressLine2,
    this.city,
    this.area,
    this.countryCode,
    this.isPrimary,
    this.status,
    this.isActive,
    this.creationDate,
    this.lastUpdateDate,
  });

  factory AddressItemDto.fromJson(Map<String, dynamic> json) {
    return AddressItemDto(
      addressId: (json['address_id'] as num?)?.toInt() ?? 0,
      addressGuid: json['address_guid'] as String?,
      addressLine1: json['address_line1'] as String?,
      addressLine2: json['address_line2'] as String?,
      city: json['city'] as String?,
      area: json['area'] as String?,
      countryCode: json['country_code'] as String?,
      isPrimary: json['is_primary'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
      creationDate: json['creation_date'] as String?,
      lastUpdateDate: json['last_update_date'] as String?,
    );
  }

  final int addressId;
  final String? addressGuid;
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? area;
  final String? countryCode;
  final String? isPrimary;
  final String? status;
  final String? isActive;
  final String? creationDate;
  final String? lastUpdateDate;

  AddressItem toDomain() => AddressItem(
    addressId: addressId,
    addressGuid: addressGuid,
    addressLine1: addressLine1,
    addressLine2: addressLine2,
    city: city,
    area: area,
    countryCode: countryCode,
    isPrimary: isPrimary,
    status: status,
    isActive: isActive,
    creationDate: creationDate,
    lastUpdateDate: lastUpdateDate,
  );
}

class WorkScheduleHistoryItemDto {
  WorkScheduleHistoryItemDto({
    required this.empSchId,
    this.empSchGuid,
    this.workScheduleId,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.status,
    this.isActive,
  });

  factory WorkScheduleHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return WorkScheduleHistoryItemDto(
      empSchId: (json['emp_sch_id'] as num?)?.toInt() ?? 0,
      empSchGuid: json['emp_sch_guid'] as String?,
      workScheduleId: (json['work_schedule_id'] as num?)?.toInt(),
      effectiveStartDate: json['effective_start_date'] as String?,
      effectiveEndDate: json['effective_end_date'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int empSchId;
  final String? empSchGuid;
  final int? workScheduleId;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? status;
  final String? isActive;

  WorkScheduleHistoryItem toDomain() => WorkScheduleHistoryItem(
    empSchId: empSchId,
    empSchGuid: empSchGuid,
    workScheduleId: workScheduleId,
    effectiveStartDate: effectiveStartDate,
    effectiveEndDate: effectiveEndDate,
    status: status,
    isActive: isActive,
  );
}

class CompensationHistoryItemDto {
  CompensationHistoryItemDto({
    required this.compId,
    this.compGuid,
    this.basicSalaryKwd,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.status,
    this.isActive,
  });

  factory CompensationHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return CompensationHistoryItemDto(
      compId: (json['comp_id'] as num?)?.toInt() ?? 0,
      compGuid: json['comp_guid'] as String?,
      basicSalaryKwd: (json['basic_salary_kwd'] as num?)?.toDouble(),
      effectiveStartDate: json['effective_start_date'] as String?,
      effectiveEndDate: json['effective_end_date'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int compId;
  final String? compGuid;
  final double? basicSalaryKwd;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? status;
  final String? isActive;

  CompensationHistoryItem toDomain() => CompensationHistoryItem(
    compId: compId,
    compGuid: compGuid,
    basicSalaryKwd: basicSalaryKwd,
    effectiveStartDate: effectiveStartDate,
    effectiveEndDate: effectiveEndDate,
    status: status,
    isActive: isActive,
  );
}

class AllowancesHistoryItemDto {
  AllowancesHistoryItemDto({
    required this.allowId,
    this.allowGuid,
    this.housingKwd,
    this.transportKwd,
    this.foodKwd,
    this.mobileKwd,
    this.otherKwd,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.status,
    this.isActive,
  });

  factory AllowancesHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return AllowancesHistoryItemDto(
      allowId: (json['allow_id'] as num?)?.toInt() ?? 0,
      allowGuid: json['allow_guid'] as String?,
      housingKwd: (json['housing_kwd'] as num?)?.toDouble(),
      transportKwd: (json['transport_kwd'] as num?)?.toDouble(),
      foodKwd: (json['food_kwd'] as num?)?.toDouble(),
      mobileKwd: (json['mobile_kwd'] as num?)?.toDouble(),
      otherKwd: (json['other_kwd'] as num?)?.toDouble(),
      effectiveStartDate: json['effective_start_date'] as String?,
      effectiveEndDate: json['effective_end_date'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int allowId;
  final String? allowGuid;
  final double? housingKwd;
  final double? transportKwd;
  final double? foodKwd;
  final double? mobileKwd;
  final double? otherKwd;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? status;
  final String? isActive;

  AllowancesHistoryItem toDomain() => AllowancesHistoryItem(
    allowId: allowId,
    allowGuid: allowGuid,
    housingKwd: housingKwd,
    transportKwd: transportKwd,
    foodKwd: foodKwd,
    mobileKwd: mobileKwd,
    otherKwd: otherKwd,
    effectiveStartDate: effectiveStartDate,
    effectiveEndDate: effectiveEndDate,
    status: status,
    isActive: isActive,
  );
}

class DocumentComplianceHistoryItemDto {
  DocumentComplianceHistoryItemDto({
    required this.docCompId,
    this.docCompGuid,
    this.civilIdExpiry,
    this.passportExpiry,
    this.visaNumber,
    this.visaExpiry,
    this.workPermitNumber,
    this.workPermitExpiry,
    this.status,
    this.isActive,
  });

  factory DocumentComplianceHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return DocumentComplianceHistoryItemDto(
      docCompId: (json['doc_comp_id'] as num?)?.toInt() ?? 0,
      docCompGuid: json['doc_comp_guid'] as String?,
      civilIdExpiry: json['civil_id_expiry'] as String?,
      passportExpiry: json['passport_expiry'] as String?,
      visaNumber: json['visa_number'] as String?,
      visaExpiry: json['visa_expiry'] as String?,
      workPermitNumber: json['work_permit_number'] as String?,
      workPermitExpiry: json['work_permit_expiry'] as String?,
      status: json['status'] as String?,
      isActive: json['is_active'] as String?,
    );
  }

  final int docCompId;
  final String? docCompGuid;
  final String? civilIdExpiry;
  final String? passportExpiry;
  final String? visaNumber;
  final String? visaExpiry;
  final String? workPermitNumber;
  final String? workPermitExpiry;
  final String? status;
  final String? isActive;

  DocumentComplianceHistoryItem toDomain() => DocumentComplianceHistoryItem(
    docCompId: docCompId,
    docCompGuid: docCompGuid,
    civilIdExpiry: civilIdExpiry,
    passportExpiry: passportExpiry,
    visaNumber: visaNumber,
    visaExpiry: visaExpiry,
    workPermitNumber: workPermitNumber,
    workPermitExpiry: workPermitExpiry,
    status: status,
    isActive: isActive,
  );
}
