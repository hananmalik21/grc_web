import 'package:grc/features/compensation/domain/models/salary_structure_management/salary_structure_location.dart';

class SalaryStructureItem {
  final int structureId;
  final String structureGuid;
  final int enterpriseId;
  final String structureCode;
  final String structureName;
  final String structureTypeCode;
  final SalaryStructureLocation? locationObj;
  final String activeFlag;
  final String createdBy;
  final DateTime? creationDate;
  final String lastUpdatedBy;
  final DateTime? lastUpdateDate;

  const SalaryStructureItem({
    required this.structureId,
    required this.structureGuid,
    required this.enterpriseId,
    required this.structureCode,
    required this.structureName,
    required this.structureTypeCode,
    required this.locationObj,
    required this.activeFlag,
    required this.createdBy,
    required this.creationDate,
    required this.lastUpdatedBy,
    required this.lastUpdateDate,
  });

  String get uiName => structureName;

  String get uiCode => structureCode;

  String get uiType => structureTypeCode.trim().isEmpty ? '-' : structureTypeCode;

  String get uiLocation => locationObj?.valueName?.trim().isNotEmpty == true ? locationObj!.valueName! : '-';

  String get uiStatus {
    final normalizedActiveFlag = activeFlag.trim().toUpperCase();
    return normalizedActiveFlag == 'Y' ? 'Active' : 'Inactive';
  }

  String get uiModifiedDate {
    final date = lastUpdateDate ?? creationDate;
    if (date == null) {
      return '-';
    }

    final localDate = date.toLocal();
    return '${localDate.day}/${localDate.month}/${localDate.year}';
  }
}
