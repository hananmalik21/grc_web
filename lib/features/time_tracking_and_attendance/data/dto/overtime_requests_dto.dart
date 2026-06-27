import 'package:grc/features/time_tracking_and_attendance/domain/models/overtime/overtime_record.dart';
import 'package:intl/intl.dart';

class OvertimeRequestsResponseDto {
  final List<OtRequestItemDto> items;
  final OtRequestPaginationDto pagination;

  const OvertimeRequestsResponseDto({required this.items, required this.pagination});

  factory OvertimeRequestsResponseDto.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final meta = json['meta'] as Map<String, dynamic>?;
    final paginationMap = meta?['pagination'] as Map<String, dynamic>?;

    final List<dynamic> rawItems = data is List ? data : (data is Map ? [] : []);
    final items = rawItems.whereType<Map<String, dynamic>>().map((e) => OtRequestItemDto.fromJson(e)).toList();

    final pagination = paginationMap != null
        ? OtRequestPaginationDto.fromJson(paginationMap)
        : const OtRequestPaginationDto(page: 1, limit: 10, total: 0, hasMore: false);

    return OvertimeRequestsResponseDto(items: items, pagination: pagination);
  }
}

class OtRequestPaginationDto {
  final int page;
  final int limit;
  final int total;
  final bool hasMore;

  const OtRequestPaginationDto({required this.page, required this.limit, required this.total, required this.hasMore});

  factory OtRequestPaginationDto.fromJson(Map<String, dynamic> json) {
    return OtRequestPaginationDto(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      total: (json['total'] as num?)?.toInt() ?? 0,
      hasMore: json['hasMore'] as bool? ?? false,
    );
  }
}

class OtRequestItemDto {
  final int otRequestId;
  final String otRequestGuid;
  final int tenantId;
  final int attendanceDayId;
  final int otRateTypeId;
  final double requestedHours;
  final String status;
  final String? reason;
  final String? creationDate;
  final int enterpriseId;
  final int employeeId;
  final String? attendanceDate;
  final String? attendanceStatus;
  final String employeeNameEn;
  final String employeeNumber;
  final List<Map<String, dynamic>> orgStructureList;
  final OtRateTypeDto? otRateTypeObj;
  final double? multiplier;
  final double? calculatedOtHours;
  final String? lastUpdateDate;
  final String? managerApprovedDate;
  final String? hrValidatedDate;

  const OtRequestItemDto({
    required this.otRequestId,
    required this.otRequestGuid,
    required this.tenantId,
    required this.attendanceDayId,
    required this.otRateTypeId,
    required this.requestedHours,
    required this.status,
    this.reason,
    this.creationDate,
    required this.enterpriseId,
    required this.employeeId,
    this.attendanceDate,
    this.attendanceStatus,
    required this.employeeNameEn,
    required this.employeeNumber,
    required this.orgStructureList,
    this.otRateTypeObj,
    this.multiplier,
    this.calculatedOtHours,
    this.lastUpdateDate,
    this.managerApprovedDate,
    this.hrValidatedDate,
  });

  factory OtRequestItemDto.fromJson(Map<String, dynamic> json) {
    final rateObj = json['ot_rate_type_obj'];
    return OtRequestItemDto(
      otRequestId: (json['ot_request_id'] as num?)?.toInt() ?? 0,
      otRequestGuid: json['ot_request_guid'] as String? ?? '',
      tenantId: (json['tenant_id'] as num?)?.toInt() ?? 0,
      attendanceDayId: (json['attendance_day_id'] as num?)?.toInt() ?? 0,
      otRateTypeId: (json['ot_rate_type_id'] as num?)?.toInt() ?? 0,
      requestedHours: (json['requested_hours'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String? ?? '',
      reason: json['reason'] as String?,
      creationDate: json['creation_date'] as String?,
      enterpriseId: (json['enterprise_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      attendanceDate: json['attendance_date'] as String?,
      attendanceStatus: json['attendance_status'] as String?,
      employeeNameEn: json['employee_name_en'] as String? ?? '',
      employeeNumber: json['employee_number'] as String? ?? '',
      orgStructureList: (json['org_structure_list'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().toList(),
      otRateTypeObj: rateObj is Map<String, dynamic> ? OtRateTypeDto.fromJson(rateObj) : null,
      multiplier: (json['multiplier'] as num?)?.toDouble(),
      calculatedOtHours: (json['calculated_ot_hours'] as num?)?.toDouble(),
      lastUpdateDate: json['last_update_date'] as String?,
      managerApprovedDate: json['manager_approved_date'] as String?,
      hrValidatedDate: json['hr_validated_date'] as String?,
    );
  }

  String _getDepartmentName() {
    for (final unit in orgStructureList) {
      if (unit['level_code'] == 'DEPARTMENT') {
        return unit['org_unit_name_en'] as String? ?? '';
      }
    }
    return '';
  }

  String _formatStatus() {
    switch (status.toUpperCase()) {
      case 'DRAFT':
        return 'Draft';
      case 'SUBMITTED':
        return 'Submitted';
      case 'APPROVED':
        return 'Approved';
      case 'REJECTED':
        return 'Rejected';
      case 'WITHDRAWN':
        return 'Withdrawn';
      case 'PENDING':
        return 'Pending';
      default:
        return status.isNotEmpty ? status[0].toUpperCase() + status.substring(1).toLowerCase() : '-';
    }
  }

  DateTime? _parseDate(String? s) {
    if (s == null || s.isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {
      return null;
    }
  }

  String _formatDateDisplay(DateTime dt) => DateFormat('MMM d, yyyy').format(dt);

  OvertimeRecord toDomain() {
    final attDate = _parseDate(attendanceDate);
    final creationDt = _parseDate(creationDate);
    final approvedDt = _parseDate(managerApprovedDate ?? hrValidatedDate);
    final rateName = otRateTypeObj?.rateName ?? '';
    final dept = _getDepartmentName();

    final dateForRecord = attDate ?? DateTime.now();
    final requestedDateForRecord = creationDt ?? attDate ?? DateTime.now();

    return OvertimeRecord(
      otRequestId: otRequestId,
      otRequestGuid: otRequestGuid.isNotEmpty ? otRequestGuid : null,
      employeeId: employeeNumber,
      date: dateForRecord,
      requestedDate: requestedDateForRecord,
      amount: calculatedOtHours?.toStringAsFixed(2) ?? requestedHours.toStringAsFixed(2),
      employeeDetail: EmployeeDetail(
        name: employeeNameEn,
        employeeId: employeeNumber,
        position: rateName,
        department: dept,
        lineManager: '',
      ),
      overtimeDetail: OvertimeDetail(
        overtimeHours: requestedHours.toStringAsFixed(1),
        regularHours: '',
        type: rateName,
        rate: multiplier?.toStringAsFixed(2) ?? '',
        amount: calculatedOtHours?.toStringAsFixed(2) ?? requestedHours.toStringAsFixed(2),
      ),
      approvalInformation: ApprovalInformation(
        status: _formatStatus(),
        byUser: '',
        date: approvedDt,
        reason: reason ?? '',
      ),
      dateDisplay: _formatDateDisplay(dateForRecord),
      requestedDateDisplay: _formatDateDisplay(requestedDateForRecord),
      approvedDateDisplay: approvedDt != null ? _formatDateDisplay(approvedDt) : '--',
    );
  }
}

class OtRateTypeDto {
  final int otRateTypeId;
  final String? rateCode;
  final String? rateName;
  final String? categoryCode;
  final String? isSystem;
  final String? isActive;

  const OtRateTypeDto({
    required this.otRateTypeId,
    this.rateCode,
    this.rateName,
    this.categoryCode,
    this.isSystem,
    this.isActive,
  });

  factory OtRateTypeDto.fromJson(Map<String, dynamic> json) {
    return OtRateTypeDto(
      otRateTypeId: (json['ot_rate_type_id'] as num?)?.toInt() ?? 0,
      rateCode: json['rate_code'] as String?,
      rateName: json['rate_name'] as String?,
      categoryCode: json['category_code'] as String?,
      isSystem: json['is_system'] as String?,
      isActive: json['is_active'] as String?,
    );
  }
}
