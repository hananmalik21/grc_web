import 'package:grc/features/hiring/presentation/utils/requisition_ui_placeholder.dart';
import 'package:grc/core/enums/hiring_enums.dart';
import 'package:intl/intl.dart';

class RequisitionSkillRowData {
  const RequisitionSkillRowData({required this.name, required this.typeCode});

  final String name;
  final String typeCode;

  bool get isRequired => typeCode.trim().toUpperCase() == 'REQUIRED';
}

class RequisitionTableRowData {
  const RequisitionTableRowData({
    required this.id,
    required this.requisitionCode,
    required this.jobTitle,
    required this.gradeNumber,
    required this.employmentTypeCode,
    required this.employmentTypeLabel,
    required this.employmentTypeKey,
    required this.department,
    required this.departmentKey,
    required this.roleTitle,
    required this.hiringManager,
    required this.location,
    required this.workModeCode,
    required this.workModeLabel,
    required this.workModeKey,
    required this.openings,
    required this.compensationRange,
    this.compensationTypeLabel = RequisitionUiPlaceholder.value,
    required this.status,
    this.statusEnum,
    this.openStatusCode,
    this.openStatusEnum,
    required this.approvalStatusLabel,
    required this.approvalCompleted,
    required this.approvalTotal,
    required this.priorityLabel,
    required this.priorityKey,
    this.targetStart,
    this.targetStartDisplay,
    this.positionSummary,
    this.keyResponsibilities,
    this.minimumQualifications,
    this.preferredQualifications,
    this.recruiterName,
    this.hrbpName,
    this.skills = const [],
  });

  final String id;
  final String requisitionCode;
  final String jobTitle;
  final String gradeNumber;
  final String employmentTypeCode;
  final String employmentTypeLabel;
  final String employmentTypeKey;
  final String department;
  final String departmentKey;
  final String roleTitle;
  final String hiringManager;
  final String location;
  final String workModeCode;
  final String workModeLabel;
  final String workModeKey;
  final int openings;
  final String compensationRange;
  final String compensationTypeLabel;
  final String status;
  final RequisitionStatus? statusEnum;
  final String? openStatusCode;
  final RequisitionOpenStatus? openStatusEnum;
  final String approvalStatusLabel;
  final int approvalCompleted;
  final int approvalTotal;
  final String priorityLabel;
  final String priorityKey;
  final DateTime? targetStart;
  final String? targetStartDisplay;
  final String? positionSummary;
  final String? keyResponsibilities;
  final String? minimumQualifications;
  final String? preferredQualifications;
  final String? recruiterName;
  final String? hrbpName;
  final List<RequisitionSkillRowData> skills;

  String? get openStatusLabel => openStatusEnum?.label;

  bool get _isApproved => statusEnum == RequisitionStatus.approved;

  bool get _isClosed => openStatusEnum == RequisitionOpenStatus.closed;

  bool get canPutOnHold => _isApproved && !_isClosed && openStatusEnum == RequisitionOpenStatus.open;

  bool get canClose =>
      _isApproved &&
      !_isClosed &&
      (openStatusEnum == RequisitionOpenStatus.open || openStatusEnum == RequisitionOpenStatus.onHold);

  bool get canActivate => _isApproved && !_isClosed && openStatusEnum == RequisitionOpenStatus.onHold;

  bool get hasGrade => !RequisitionUiPlaceholder.isPlaceholder(gradeNumber);
  bool get hasEmploymentType => !RequisitionUiPlaceholder.isPlaceholder(employmentTypeLabel);
  bool get hasRoleTitle => !RequisitionUiPlaceholder.isPlaceholder(roleTitle);
  bool get hasHiringManager => !RequisitionUiPlaceholder.isPlaceholder(hiringManager);
  bool get hasLocation => !RequisitionUiPlaceholder.isPlaceholder(location);
  bool get hasWorkMode => !RequisitionUiPlaceholder.isPlaceholder(workModeLabel);
  bool get hasPriority => !RequisitionUiPlaceholder.isPlaceholder(priorityLabel);
  bool get hasApprovalProgress => approvalTotal > 0;
  bool get hasRecruiter => recruiterName != null && !RequisitionUiPlaceholder.isPlaceholder(recruiterName);
  bool get hasHrbp => hrbpName != null && !RequisitionUiPlaceholder.isPlaceholder(hrbpName);
  bool get hasPositionSummary => positionSummary != null && !RequisitionUiPlaceholder.isPlaceholder(positionSummary);

  List<RequisitionSkillRowData> get requiredSkills => skills.where((skill) => skill.isRequired).toList();

  List<RequisitionSkillRowData> get preferredSkills => skills.where((skill) => !skill.isRequired).toList();

  String get approvalLabel =>
      hasApprovalProgress ? '$approvalCompleted/$approvalTotal' : RequisitionUiPlaceholder.value;

  double get approvalProgress => approvalTotal <= 0 ? 0 : approvalCompleted / approvalTotal;

  String targetStartLabel({String? locale}) {
    final display = targetStartDisplay?.trim();
    if (display != null && display.isNotEmpty) {
      return display;
    }

    final date = targetStart;
    if (date == null) return RequisitionUiPlaceholder.value;

    if (locale != null && locale.isNotEmpty) {
      return DateFormat.yMMMd(locale).format(date);
    }
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
