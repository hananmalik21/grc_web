class Adjustment {
  final int adjustmentId;
  final String adjustmentGuid;
  final int enterpriseId;
  final int employeeId;
  final int? planId;
  final int? componentId;
  final String adjustmentType;
  final DateTime effectiveDate;
  final String reasonCode;
  final String? budgetCode;
  final String? justificationText;
  final String? performanceRating;
  final String? internalNotes;
  final String status;
  final String activeFlag;
  final String createdBy;
  final DateTime creationDate;
  final String lastUpdatedBy;
  final DateTime lastUpdateDate;
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
  final List<AdjustmentOrgUnit> orgStructureList;
  final double totalSalary;
  final double previousSalary;
  final double salaryDifferencePercent;
  final List<AdjustmentAssignmentDetail> assignmentDetails;
  final List<String> fileUrls;

  const Adjustment({
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
    required this.assignmentDetails,
    required this.fileUrls,
  });

  String get fullNameEn => '$firstNameEn $middleNameEn $lastNameEn'.trim();
  String get fullNameAr => '$firstNameAr $middleNameAr $lastNameAr'.trim();

  String get departmentName {
    const departmentLevel = 4;
    final dept = orgStructureList.where((u) => u.level == departmentLevel).firstOrNull;
    return dept?.orgUnitNameEn ?? '';
  }

  String get companyName {
    const companyLevel = 1;
    final company = orgStructureList.where((u) => u.level == companyLevel).firstOrNull;
    return company?.orgUnitNameEn ?? '';
  }

  String get regionName {
    // In this project, region often maps to level 2 or similar.
    // Let's use level 2 for region as seen in mock data (Synexis Operations)
    const regionLevel = 2;
    final region = orgStructureList.where((u) => u.level == regionLevel).firstOrNull;
    return region?.orgUnitNameEn ?? '';
  }
}

class AdjustmentOrgUnit {
  final int level;
  final String orgUnitId;
  final String orgUnitCode;
  final String orgUnitNameEn;
  final String orgUnitNameAr;
  final String levelCode;
  final String status;
  final String isActive;

  const AdjustmentOrgUnit({
    required this.level,
    required this.orgUnitId,
    required this.orgUnitCode,
    required this.orgUnitNameEn,
    required this.orgUnitNameAr,
    required this.levelCode,
    required this.status,
    required this.isActive,
  });
}

class AdjustmentAssignmentDetail {
  final int assignmentDetailId;
  final String assignmentDetailGuid;
  final int enterpriseId;
  final int employeeId;
  final int planId;
  final int adjustmentId;
  final String changeSource;
  final String currencyCode;
  final int componentId;
  final double amount;
  final DateTime effectiveStartDate;
  final DateTime? effectiveEndDate;
  final String activeFlag;
  final String createdBy;
  final DateTime creationDate;
  final String lastUpdatedBy;
  final DateTime lastUpdateDate;
  final AdjustmentComponent? component;

  const AdjustmentAssignmentDetail({
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
}

class AdjustmentComponent {
  final int componentId;
  final String componentGuid;
  final String componentCode;
  final String componentName;
  final String? description;
  final String componentTypeCode;
  final String calculationMethodCode;
  final String? baseAmountSource;
  final String? formulaName;
  final double minValue;
  final double maxValue;
  final String currencyCode;
  final DateTime effectiveStartDate;
  final DateTime effectiveEndDate;
  final String activeFlag;
  final String createdBy;
  final DateTime creationDate;
  final String lastUpdatedBy;
  final DateTime lastUpdateDate;

  const AdjustmentComponent({
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
}
