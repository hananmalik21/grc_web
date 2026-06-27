class RequisitionDetail {
  const RequisitionDetail({
    required this.employmentTypeCode,
    required this.numberOfOpenings,
    required this.priorityCode,
    required this.workModeCode,
    this.primaryLocationId,
    this.primaryLocationName,
    this.primaryLocationText,
    this.targetStartDate,
    this.targetStartDateDisplay,
    this.expectedEndDate,
    this.expectedEndDateDisplay,
  });

  static const empty = RequisitionDetail(
    employmentTypeCode: '',
    numberOfOpenings: 0,
    priorityCode: '',
    workModeCode: '',
  );

  final String employmentTypeCode;
  final int numberOfOpenings;
  final String priorityCode;
  final String workModeCode;
  final String? primaryLocationId;
  final String? primaryLocationName;
  final String? primaryLocationText;
  final DateTime? targetStartDate;
  final String? targetStartDateDisplay;
  final DateTime? expectedEndDate;
  final String? expectedEndDateDisplay;

  String get locationDisplay {
    final name = primaryLocationName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final text = primaryLocationText?.trim();
    if (text != null && text.isNotEmpty) return text;
    return '';
  }
}
