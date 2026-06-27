class PlanOwner {
  final int employeeId;
  final String employeeGuid;
  final int enterpriseId;
  final String firstNameEn;
  final String lastNameEn;
  final String fullNameEn;
  final String? email;
  final String? phone;
  final String? status;

  const PlanOwner({
    required this.employeeId,
    required this.employeeGuid,
    required this.enterpriseId,
    required this.firstNameEn,
    required this.lastNameEn,
    required this.fullNameEn,
    this.email,
    this.phone,
    this.status,
  });

  String get displayInitials {
    if (fullNameEn.isEmpty) return '---';
    final parts = fullNameEn.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  String get displayName => fullNameEn.isNotEmpty ? fullNameEn : '---';
}

class PlanAttribute {
  final int attributeId;
  final String attributeGuid;
  final String attributeCode;
  final String attributeValue;
  final String activeFlag;

  const PlanAttribute({
    required this.attributeId,
    required this.attributeGuid,
    required this.attributeCode,
    required this.attributeValue,
    required this.activeFlag,
  });
}

class PlanBudget {
  final int budgetId;
  final double budgetAmount;
  final String currencyCode;

  const PlanBudget({required this.budgetId, required this.budgetAmount, required this.currencyCode});
}

class PlanBusinessUnit {
  final int id;
  final String guid;
  final String orgUnitId;
  final OrgUnitObj? orgUnit;

  const PlanBusinessUnit({required this.id, required this.guid, required this.orgUnitId, this.orgUnit});
}

class OrgUnitObj {
  final String id;
  final String code;
  final String nameEn;
  final String nameAr;
  final String levelCode;
  final String? parentOrgUnitId;

  const OrgUnitObj({
    required this.id,
    required this.code,
    required this.nameEn,
    required this.nameAr,
    required this.levelCode,
    this.parentOrgUnitId,
  });
}

class PlanComponentAdvancedSettings {
  final bool prorated;
  final bool taxable;
  final bool pensionable;
  final bool statutory;
  final bool includeInCtc;
  final bool optional;
  final bool amortizable;
  final bool recurring;
  final bool isActive;
  final String? payBasis;

  const PlanComponentAdvancedSettings({
    this.prorated = false,
    this.taxable = false,
    this.pensionable = false,
    this.statutory = false,
    this.includeInCtc = false,
    this.optional = false,
    this.amortizable = false,
    this.recurring = false,
    this.isActive = true,
    this.payBasis,
  });
}

class PlanComponent {
  final int id;
  final int componentId;
  final int displaySequence;
  final String mandatoryFlag;
  final String? frequencyCode;
  final String? activeFlag;
  final ComponentObj? component;
  final PlanComponentAdvancedSettings? advancedSettings;

  const PlanComponent({
    required this.id,
    required this.componentId,
    required this.displaySequence,
    required this.mandatoryFlag,
    this.frequencyCode,
    this.activeFlag,
    this.component,
    this.advancedSettings,
  });

  @override
  bool operator ==(Object other) => other is PlanComponent && other.id == id;

  @override
  int get hashCode => id.hashCode;

  bool get isMandatory => mandatoryFlag.trim().toUpperCase() == 'Y';
  bool get isActive => activeFlag?.trim().toUpperCase() == 'Y';

  String get componentName => component?.displayName ?? '---';
  String get componentCode => component?.displayCode ?? '---';
  String get componentType => component?.displayType ?? '---';
  String get componentCategory => component?.displayCategory ?? '---';
  String get componentStatus => component?.displayStatus ?? '---';
  String get componentDescription => component?.displayDescription ?? '---';
  String get componentRange => component?.displayRange ?? '---';
}

class ComponentObj {
  final int id;
  final String guid;
  final String code;
  final String name;
  final String typeCode;
  final String calculationMethod;
  final String status;
  final String categoryCode;
  final String? description;
  final double? minValue;
  final double? maxValue;
  final String? currencyCode;

  const ComponentObj({
    required this.id,
    required this.guid,
    required this.code,
    required this.name,
    required this.typeCode,
    required this.calculationMethod,
    required this.status,
    required this.categoryCode,
    this.description,
    this.minValue,
    this.maxValue,
    this.currencyCode,
  });

  String get displayName => name.trim().isNotEmpty ? name : '---';
  String get displayCode => code.trim().isNotEmpty ? code : '---';
  String get displayType => typeCode.trim().isNotEmpty ? typeCode : '---';
  String get displayCalculationMethod => calculationMethod.trim().isNotEmpty ? calculationMethod : '---';
  String get displayStatus => status.trim().isNotEmpty ? status : '---';
  String get displayCategory => categoryCode.trim().isNotEmpty ? categoryCode : '---';
  String get displayDescription => (description ?? '').trim().isNotEmpty ? description! : '---';
  String get displayCurrency => (currencyCode ?? '').trim();

  String get displayRange {
    if (minValue == null && maxValue == null) {
      return '---';
    }
    final rangeValue = '${minValue?.toStringAsFixed(0) ?? '—'} - ${maxValue?.toStringAsFixed(0) ?? '—'}';
    final currency = displayCurrency;
    return currency.isNotEmpty ? '$currency $rangeValue' : rangeValue;
  }
}

class PlanEmploymentType {
  final int id;
  final String guid;
  final String typeCode;

  const PlanEmploymentType({required this.id, required this.guid, required this.typeCode});
}

class PlanGrade {
  final int id;
  final int gradeId;
  final GradeObj? grade;

  const PlanGrade({required this.id, required this.gradeId, this.grade});
}

class GradeObj {
  final int id;
  final String number;
  final String category;
  final String currencyCode;
  final double? step1Salary;
  final double? step2Salary;
  final double? step3Salary;
  final double? step4Salary;
  final double? step5Salary;

  const GradeObj({
    required this.id,
    required this.number,
    required this.category,
    required this.currencyCode,
    this.step1Salary,
    this.step2Salary,
    this.step3Salary,
    this.step4Salary,
    this.step5Salary,
  });
}

class PlanJobFamily {
  final int id;
  final String guid;
  final int jobFamilyId;
  final JobFamilyObj? jobFamily;

  const PlanJobFamily({required this.id, required this.guid, required this.jobFamilyId, this.jobFamily});
}

class JobFamilyObj {
  final int id;
  final String code;
  final String nameEn;
  final String nameAr;

  const JobFamilyObj({required this.id, required this.code, required this.nameEn, required this.nameAr});
}

class PlanLocation {
  final int id;
  final String guid;
  final int countryId;
  final LocationObj? location;

  const PlanLocation({required this.id, required this.guid, required this.countryId, this.location});
}

class LocationObj {
  final String name;
  final String type;

  const LocationObj({required this.name, required this.type});
}

class PlanPosition {
  final int id;
  final String positionId;
  final PositionObj? position;

  const PlanPosition({required this.id, required this.positionId, this.position});
}

class PositionObj {
  final String id;
  final String code;
  final String titleEn;
  final String titleAr;
  final double? salaryAmount;

  const PositionObj({
    required this.id,
    required this.code,
    required this.titleEn,
    required this.titleAr,
    this.salaryAmount,
  });
}

class PlanSalaryStructure {
  final int id;
  final String guid;
  final int structureId;
  final SalaryStructureObj? structure;

  const PlanSalaryStructure({required this.id, required this.guid, required this.structureId, this.structure});
}

class SalaryStructureObj {
  final int id;
  final String guid;
  final String code;
  final String name;
  final String currencyCode;
  final String structureTypeCode;

  const SalaryStructureObj({
    required this.id,
    required this.guid,
    required this.code,
    required this.name,
    required this.currencyCode,
    this.structureTypeCode = '',
  });
}
