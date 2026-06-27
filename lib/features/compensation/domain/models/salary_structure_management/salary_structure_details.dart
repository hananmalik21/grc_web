import 'salary_structure_detail_component.dart';

class SalaryStructureDetails {
  final int structureId;
  final String structureGuid;
  final int enterpriseId;
  final String structureCode;
  final String structureName;
  final String structureTypeCode;
  final String currencyCode;
  final bool isActive;
  final List<String> employmentTypeCodes;
  final List<int> jobFamilyIds;
  final List<String> positionIds;
  final List<int> gradeIds;
  final List<SalaryStructureDetailComponent> components;

  const SalaryStructureDetails({
    required this.structureId,
    required this.structureGuid,
    required this.enterpriseId,
    required this.structureCode,
    required this.structureName,
    required this.structureTypeCode,
    required this.currencyCode,
    required this.isActive,
    required this.employmentTypeCodes,
    required this.jobFamilyIds,
    required this.positionIds,
    required this.gradeIds,
    required this.components,
  });
}
