import 'package:grc/core/enums/overtime_status.dart';
import 'package:intl/intl.dart';

class OvertimeRecord {
  static const String _placeholder = '--';

  final int? otRequestId;
  final String? otRequestGuid;
  final String employeeId;
  final DateTime date;
  final DateTime requestedDate;
  final String amount;
  final EmployeeDetail? employeeDetail;
  final OvertimeDetail? overtimeDetail;
  final ApprovalInformation? approvalInformation;

  final String dateDisplay;
  final String requestedDateDisplay;
  final String approvedDateDisplay;

  OvertimeRecord({
    this.otRequestId,
    this.otRequestGuid,
    required this.employeeId,
    required this.date,
    required this.requestedDate,
    required this.amount,
    required this.employeeDetail,
    required this.overtimeDetail,
    required this.approvalInformation,
    required this.dateDisplay,
    required this.requestedDateDisplay,
    required this.approvedDateDisplay,
  });

  String get employeeNameDisplay =>
      (employeeDetail?.name != null && employeeDetail!.name.isNotEmpty) ? employeeDetail!.name : _placeholder;

  String get employeeIdDisplay => employeeId.isNotEmpty ? employeeId : _placeholder;

  String get positionDisplay => (employeeDetail?.position != null && employeeDetail!.position.isNotEmpty)
      ? employeeDetail!.position
      : _placeholder;

  String get departmentDisplay => (employeeDetail?.department != null && employeeDetail!.department.isNotEmpty)
      ? employeeDetail!.department
      : _placeholder;

  String get lineManagerDisplay => (employeeDetail?.lineManager != null && employeeDetail!.lineManager.isNotEmpty)
      ? employeeDetail!.lineManager
      : _placeholder;

  String get regularHoursDisplay => (overtimeDetail?.regularHours != null && overtimeDetail!.regularHours.isNotEmpty)
      ? overtimeDetail!.regularHours
      : _placeholder;

  String get overtimeHoursDisplay => (overtimeDetail?.overtimeHours != null && overtimeDetail!.overtimeHours.isNotEmpty)
      ? overtimeDetail!.overtimeHours
      : _placeholder;

  String get typeDisplay =>
      (overtimeDetail?.type != null && overtimeDetail!.type.isNotEmpty) ? overtimeDetail!.type : _placeholder;

  String get rateDisplay =>
      (overtimeDetail?.rate != null && overtimeDetail!.rate.isNotEmpty) ? overtimeDetail!.rate : _placeholder;

  String get amountDisplay => amount.isNotEmpty ? amount : _placeholder;

  String get statusDisplay => (approvalInformation?.status != null && approvalInformation!.status.isNotEmpty)
      ? approvalInformation!.status
      : _placeholder;

  String get approvedByDisplay => (approvalInformation?.byUser != null && approvalInformation!.byUser.isNotEmpty)
      ? approvalInformation!.byUser
      : _placeholder;

  String get reasonDisplay => (approvalInformation?.reason != null && approvalInformation!.reason.isNotEmpty)
      ? approvalInformation!.reason
      : _placeholder;

  static OvertimeRecord empty() {
    final now = DateTime.now();
    return OvertimeRecord(
      employeeId: "",
      date: now,
      requestedDate: now,
      amount: "",
      employeeDetail: null,
      overtimeDetail: null,
      approvalInformation: null,
      dateDisplay: _placeholder,
      requestedDateDisplay: _placeholder,
      approvedDateDisplay: _placeholder,
    );
  }

  static OvertimeRecord updatedFromActionResponse(OvertimeRecord current, Map<String, dynamic> data) {
    final statusRaw = data['status'] as String? ?? '';
    final statusLabel = OvertimeStatus.fromString(statusRaw).label;
    final byUser = data['manager_approved_by'] as String? ?? '';
    final dateStr = data['manager_approved_date'] as String? ?? data['hr_validated_date'] as String?;
    DateTime? approvedDt;
    if (dateStr != null && dateStr.toString().isNotEmpty) {
      try {
        approvedDt = DateTime.parse(dateStr.toString());
      } catch (_) {}
    }
    final reason = data['reason'] as String? ?? current.approvalInformation?.reason ?? '';
    final approvedDateDisplay = approvedDt != null ? DateFormat('MMM d, yyyy').format(approvedDt) : '--';

    final newApproval = ApprovalInformation(
      status: statusLabel,
      byUser: byUser,
      date: approvedDt ?? current.approvalInformation?.date,
      reason: reason,
    );

    return current.copyWith(approvalInformation: newApproval, approvedDateDisplay: approvedDateDisplay);
  }

  /// Merges draft update (PATCH) response into the current record.
  static OvertimeRecord updatedFromDraftUpdate(OvertimeRecord current, Map<String, dynamic> data) {
    final requestedHours = (data['requested_hours'] as num?)?.toDouble() ?? 0;
    final reason = data['reason'] as String? ?? current.approvalInformation?.reason ?? '';
    final hoursStr = requestedHours > 0
        ? requestedHours.toStringAsFixed(1)
        : current.overtimeDetail?.overtimeHours ?? '';
    final amountStr = requestedHours > 0 ? requestedHours.toStringAsFixed(2) : current.amount;
    final newOvertime = current.overtimeDetail?.copyWith(overtimeHours: hoursStr, amount: amountStr);
    final newApproval =
        current.approvalInformation?.copyWith(reason: reason) ??
        ApprovalInformation(status: 'Draft', byUser: '', date: null, reason: reason);
    return current.copyWith(
      amount: amountStr,
      overtimeDetail: newOvertime ?? current.overtimeDetail,
      approvalInformation: newApproval,
    );
  }

  OvertimeRecord copyWith({
    int? otRequestId,
    String? otRequestGuid,
    String? employeeId,
    DateTime? date,
    DateTime? requestedDate,
    String? amount,
    EmployeeDetail? employeeDetail,
    OvertimeDetail? overtimeDetail,
    ApprovalInformation? approvalInformation,
    String? dateDisplay,
    String? requestedDateDisplay,
    String? approvedDateDisplay,
  }) {
    return OvertimeRecord(
      otRequestId: otRequestId ?? this.otRequestId,
      otRequestGuid: otRequestGuid ?? this.otRequestGuid,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      requestedDate: requestedDate ?? this.requestedDate,
      amount: amount ?? this.amount,
      employeeDetail: employeeDetail ?? this.employeeDetail,
      overtimeDetail: overtimeDetail ?? this.overtimeDetail,
      approvalInformation: approvalInformation ?? this.approvalInformation,
      dateDisplay: dateDisplay ?? this.dateDisplay,
      requestedDateDisplay: requestedDateDisplay ?? this.requestedDateDisplay,
      approvedDateDisplay: approvedDateDisplay ?? this.approvedDateDisplay,
    );
  }
}

class EmployeeDetail {
  final String name;
  final String employeeId;
  final String position;
  final String department;
  final String lineManager;

  EmployeeDetail({
    required this.name,
    required this.employeeId,
    required this.position,
    required this.department,
    required this.lineManager,
  });

  static EmployeeDetail empty() {
    return EmployeeDetail(name: "", employeeId: "", position: "", department: "", lineManager: "");
  }

  EmployeeDetail copyWith({
    String? name,
    String? employeeId,
    String? position,
    String? department,
    String? lineManager,
  }) {
    return EmployeeDetail(
      name: name ?? this.name,
      employeeId: employeeId ?? this.employeeId,
      position: position ?? this.position,
      department: department ?? this.department,
      lineManager: lineManager ?? this.lineManager,
    );
  }
}

class OvertimeDetail {
  final String overtimeHours;
  final String regularHours;
  final String type;
  final String rate;
  final String amount;

  OvertimeDetail({
    required this.overtimeHours,
    required this.regularHours,
    required this.type,

    required this.rate,
    required this.amount,
  });

  static OvertimeDetail empty() {
    return OvertimeDetail(overtimeHours: "", regularHours: "", type: "", rate: "", amount: "");
  }

  OvertimeDetail copyWith({String? overtimeHours, String? regularHours, String? type, String? rate, String? amount}) {
    return OvertimeDetail(
      overtimeHours: overtimeHours ?? this.overtimeHours,
      regularHours: regularHours ?? this.regularHours,
      type: type ?? this.type,
      rate: rate ?? this.rate,
      amount: amount ?? this.amount,
    );
  }
}

class ApprovalInformation {
  final String status;
  final String byUser;
  final DateTime? date;
  final String reason;

  ApprovalInformation({required this.status, required this.byUser, this.date, required this.reason});

  static ApprovalInformation empty() {
    return ApprovalInformation(status: "", byUser: "", date: null, reason: "");
  }

  ApprovalInformation copyWith({String? status, String? byUser, DateTime? date, String? reason}) {
    return ApprovalInformation(
      status: status ?? this.status,
      byUser: byUser ?? this.byUser,
      date: date ?? this.date,
      reason: reason ?? this.reason,
    );
  }
}
