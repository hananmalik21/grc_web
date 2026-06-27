class EmployeeFullDetails {
  const EmployeeFullDetails({
    required this.employee,
    required this.assignment,
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

  final EmployeeDetailSection employee;
  final AssignmentDetailSection assignment;
  final DemographicsDetailSection? demographics;
  final WorkScheduleDetailSection? workSchedule;
  final CompensationDetailSection? compensation;
  final AllowancesDetailSection? allowances;
  final DocumentComplianceDetailSection? documentCompliance;
  final List<DocumentItem> documents;
  final List<EmergencyContactItem> emergencyContacts;
  final List<BankAccountItem> bankAccounts;
  final List<AddressItem> addresses;
  final List<WorkScheduleHistoryItem> workSchedules;
  final List<CompensationHistoryItem> compensationHistory;
  final List<AllowancesHistoryItem> allowancesHistory;
  final List<DocumentComplianceHistoryItem> documentComplianceHistory;
}

class EmployeeDetailSection {
  const EmployeeDetailSection({
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

  String get fullNameEn => [
    firstNameEn,
    middleNameEn,
    lastNameEn,
    fourthNameEn,
  ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' ').trim();
  String get fullNameAr => [
    firstNameAr,
    middleNameAr,
    lastNameAr,
    fourthNameAr,
  ].whereType<String>().where((s) => s.trim().isNotEmpty).join(' ').trim();
}

class AssignmentPositionInfo {
  const AssignmentPositionInfo({
    required this.positionId,
    required this.positionCode,
    required this.positionNameEn,
    required this.positionNameAr,
    this.budgetedMinKd,
    this.budgetedMaxKd,
  });

  final String positionId;
  final String positionCode;
  final String positionNameEn;
  final String positionNameAr;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;
}

class AssignmentJobFamilyInfo {
  const AssignmentJobFamilyInfo({
    required this.jobFamilyId,
    required this.jobFamilyCode,
    required this.jobFamilyNameEn,
    required this.jobFamilyNameAr,
  });

  final int jobFamilyId;
  final String jobFamilyCode;
  final String jobFamilyNameEn;
  final String jobFamilyNameAr;
}

class AssignmentJobLevelInfo {
  const AssignmentJobLevelInfo({
    required this.jobLevelId,
    required this.jobLevelCode,
    required this.jobLevelNameEn,
    required this.minGradeId,
    required this.maxGradeId,
  });

  final int jobLevelId;
  final String jobLevelCode;
  final String jobLevelNameEn;
  final int minGradeId;
  final int maxGradeId;
}

class AssignmentGradeInfo {
  const AssignmentGradeInfo({
    required this.gradeId,
    required this.gradeNumber,
    required this.gradeCategory,
    required this.currencyCode,
    required this.step1Salary,
    required this.step2Salary,
    required this.step3Salary,
    required this.step4Salary,
    required this.step5Salary,
    required this.gradeStatus,
  });

  final int gradeId;
  final String gradeNumber;
  final String gradeCategory;
  final String currencyCode;
  final double step1Salary;
  final double step2Salary;
  final double step3Salary;
  final double step4Salary;
  final double step5Salary;
  final String gradeStatus;
}

class AssignmentDetailSection {
  const AssignmentDetailSection({
    required this.assignmentId,
    this.assignmentGuid,
    this.orgUnitId,
    this.orgStructureList = const [],
    this.positionId,
    this.positionNameEn,
    this.positionCode,
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
    this.position,
    this.jobFamily,
    this.jobLevel,
    this.grade,
    this.budgetedMinKd,
    this.budgetedMaxKd,
  });

  final int assignmentId;
  final String? assignmentGuid;
  final String? orgUnitId;
  final List<OrgStructureItem> orgStructureList;
  final String? positionId;
  final String? positionNameEn;
  final String? positionCode;
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
  final AssignmentPositionInfo? position;
  final AssignmentJobFamilyInfo? jobFamily;
  final AssignmentJobLevelInfo? jobLevel;
  final AssignmentGradeInfo? grade;
  final double? budgetedMinKd;
  final double? budgetedMaxKd;

  (int years, int months, int days)? get servicePeriod {
    if (enterpriseHireDate == null || enterpriseHireDate!.trim().isEmpty) {
      return null;
    }
    try {
      final start = DateTime.parse(enterpriseHireDate!.trim());
      final now = DateTime.now();
      var years = now.year - start.year;
      var months = now.month - start.month;

      if (months < 0) {
        years--;
        months += 12;
      }

      if (years < 0) {
        return null;
      }

      final monthAdjustedStart = DateTime(start.year + years, start.month + months, start.day);
      var days = now.difference(monthAdjustedStart).inDays;

      if (days < 0) {
        if (months > 0) {
          months -= 1;
          final prevMonthStart = DateTime(start.year + years, start.month + months, start.day);
          days = now.difference(prevMonthStart).inDays;
        } else {
          return null;
        }
      }

      return (years, months, days);
    } catch (_) {
      return null;
    }
  }
}

class OrgStructureItem {
  const OrgStructureItem({
    required this.level,
    required this.orgUnitId,
    this.orgUnitCode,
    this.orgUnitNameEn,
    this.orgUnitNameAr,
    this.levelCode,
    this.status,
    this.isActive,
  });

  final int level;
  final String orgUnitId;
  final String? orgUnitCode;
  final String? orgUnitNameEn;
  final String? orgUnitNameAr;
  final String? levelCode;
  final String? status;
  final String? isActive;
}

class DemographicsDetailSection {
  const DemographicsDetailSection({
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
}

class WorkScheduleDetailSection {
  const WorkScheduleDetailSection({
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

  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final int? empSchId;
  final String? empSchGuid;
  final int? workScheduleId;
  final String? wsStart;
  final String? wsEnd;
  final String? wsStatus;
  final String? wsIsActive;
}

class CompensationDetailSection {
  const CompensationDetailSection({
    this.compId,
    this.compGuid,
    this.basicSalaryKwd,
    this.compStart,
    this.compEnd,
    this.compStatus,
    this.compIsActive,
  });

  final int? compId;
  final String? compGuid;
  final double? basicSalaryKwd;
  final String? compStart;
  final String? compEnd;
  final String? compStatus;
  final String? compIsActive;
}

class AllowancesDetailSection {
  const AllowancesDetailSection({
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
}

class DocumentComplianceDetailSection {
  const DocumentComplianceDetailSection({
    this.docCompId,
    this.docCompGuid,
    this.civilIdExpiry,
    this.passportExpiry,
    this.doccStatus,
    this.doccIsActive,
  });

  final int? docCompId;
  final String? docCompGuid;
  final String? civilIdExpiry;
  final String? passportExpiry;
  final String? doccStatus;
  final String? doccIsActive;
}

class DocumentItem {
  const DocumentItem({
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

  String? fullAccessUrl(String baseUrl) {
    final url = accessUrl;
    if (url == null || url.trim().isEmpty) return null;
    final trimmed = url.trim();
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }
    final base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';
    final path = trimmed.startsWith('/') ? trimmed.substring(1) : trimmed;
    return base + path;
  }
}

class EmergencyContactItem {
  const EmergencyContactItem({
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

  final int emergId;
  final String? emergGuid;
  final String? contactName;
  final String? relationshipCode;
  final String? phoneNumber;
  final String? email;
  final String? address;
  final String? status;
  final String? isActive;
}

class BankAccountItem {
  const BankAccountItem({
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
}

class AddressItem {
  const AddressItem({
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
}

class WorkScheduleHistoryItem {
  const WorkScheduleHistoryItem({
    required this.empSchId,
    this.empSchGuid,
    this.workScheduleId,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.status,
    this.isActive,
  });

  final int empSchId;
  final String? empSchGuid;
  final int? workScheduleId;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? status;
  final String? isActive;
}

class CompensationHistoryItem {
  const CompensationHistoryItem({
    required this.compId,
    this.compGuid,
    this.basicSalaryKwd,
    this.effectiveStartDate,
    this.effectiveEndDate,
    this.status,
    this.isActive,
  });

  final int compId;
  final String? compGuid;
  final double? basicSalaryKwd;
  final String? effectiveStartDate;
  final String? effectiveEndDate;
  final String? status;
  final String? isActive;
}

class AllowancesHistoryItem {
  const AllowancesHistoryItem({
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
}

class DocumentComplianceHistoryItem {
  const DocumentComplianceHistoryItem({
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
}
