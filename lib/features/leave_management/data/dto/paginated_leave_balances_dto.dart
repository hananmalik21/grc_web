import 'package:grc/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance.dart';

class LeaveBalanceEmployeeInfoDto {
  final int employeeId;
  final String employeeGuid;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? firstNameAr;
  final String? middleNameAr;
  final String? lastNameAr;
  final String? email;

  const LeaveBalanceEmployeeInfoDto({
    required this.employeeId,
    required this.employeeGuid,
    this.firstName,
    this.middleName,
    this.lastName,
    this.firstNameAr,
    this.middleNameAr,
    this.lastNameAr,
    this.email,
  });

  factory LeaveBalanceEmployeeInfoDto.fromJson(Map<String, dynamic> json) {
    return LeaveBalanceEmployeeInfoDto(
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: json['employee_guid'] as String? ?? '',
      firstName: json['first_name'] as String?,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String?,
      firstNameAr: json['first_name_ar'] as String?,
      middleNameAr: json['middle_name_ar'] as String?,
      lastNameAr: json['last_name_ar'] as String?,
      email: json['email'] as String?,
    );
  }

  String get fullName {
    final parts = [firstName, middleName, lastName].whereType<String>();
    return parts.join(' ').trim();
  }
}

class LeaveBalanceDto {
  final String employeeLeaveBalanceGuid;
  final int tenantId;
  final int employeeId;
  final String employeeGuid;
  final int leaveTypeId;
  final double openingBalanceDays;
  final double accruedDays;
  final double takenDays;
  final double adjustedDays;
  final double availableDays;
  final DateTime? lastAccrualDate;
  final DateTime? periodStartDate;
  final DateTime? periodEndDate;
  final String status;
  final DateTime? creationDate;
  final String? createdBy;
  final DateTime? lastUpdateDate;
  final String? lastUpdatedBy;
  final LeaveBalanceEmployeeInfoDto? employeeInfo;

  const LeaveBalanceDto({
    required this.employeeLeaveBalanceGuid,
    required this.tenantId,
    required this.employeeId,
    required this.employeeGuid,
    required this.leaveTypeId,
    required this.openingBalanceDays,
    required this.accruedDays,
    required this.takenDays,
    required this.adjustedDays,
    required this.availableDays,
    this.lastAccrualDate,
    this.periodStartDate,
    this.periodEndDate,
    required this.status,
    this.creationDate,
    this.createdBy,
    this.lastUpdateDate,
    this.lastUpdatedBy,
    this.employeeInfo,
  });

  factory LeaveBalanceDto.fromJson(Map<String, dynamic> json) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    final employeeInfoJson = json['employee_info'] as Map<String, dynamic>?;

    return LeaveBalanceDto(
      employeeLeaveBalanceGuid: json['employee_leave_balance_guid'] as String? ?? '',
      tenantId: (json['tenant_id'] as num?)?.toInt() ?? 0,
      employeeId: (json['employee_id'] as num?)?.toInt() ?? 0,
      employeeGuid: json['employee_guid'] as String? ?? '',
      leaveTypeId: (json['leave_type_id'] as num?)?.toInt() ?? 0,
      openingBalanceDays: parseDouble(json['opening_balance_days']),
      accruedDays: parseDouble(json['accrued_days']),
      takenDays: parseDouble(json['taken_days']),
      adjustedDays: parseDouble(json['adjusted_days']),
      availableDays: parseDouble(json['available_days']),
      lastAccrualDate: parseDateTime(json['last_accrual_date']),
      periodStartDate: parseDateTime(json['period_start_date']),
      periodEndDate: parseDateTime(json['period_end_date']),
      status: json['status'] as String? ?? 'ACTIVE',
      creationDate: parseDateTime(json['creation_date']),
      createdBy: json['created_by'] as String?,
      lastUpdateDate: parseDateTime(json['last_update_date']),
      lastUpdatedBy: json['last_updated_by'] as String?,
      employeeInfo: employeeInfoJson != null ? LeaveBalanceEmployeeInfoDto.fromJson(employeeInfoJson) : null,
    );
  }

  LeaveBalance toDomain() {
    final name = employeeInfo?.fullName ?? '';
    return LeaveBalance(
      employeeLeaveBalanceGuid: employeeLeaveBalanceGuid,
      tenantId: tenantId,
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      employeeName: name,
      leaveTypeId: leaveTypeId,
      openingBalanceDays: openingBalanceDays,
      accruedDays: accruedDays,
      takenDays: takenDays,
      adjustedDays: adjustedDays,
      availableDays: availableDays,
      lastAccrualDate: lastAccrualDate,
      periodStartDate: periodStartDate,
      periodEndDate: periodEndDate,
      status: status,
      creationDate: creationDate,
      createdBy: createdBy,
      lastUpdateDate: lastUpdateDate,
      lastUpdatedBy: lastUpdatedBy,
    );
  }
}

class PaginatedLeaveBalancesDto {
  final bool success;
  final String message;
  final PaginationInfoDto pagination;
  final List<LeaveBalanceDto> data;

  const PaginatedLeaveBalancesDto({
    required this.success,
    required this.message,
    required this.pagination,
    required this.data,
  });

  factory PaginatedLeaveBalancesDto.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = meta['pagination'] as Map<String, dynamic>? ?? {};

    return PaginatedLeaveBalancesDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      pagination: PaginationInfoDto.fromJson(paginationJson),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => LeaveBalanceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  PaginatedLeaveBalances toDomain() {
    return PaginatedLeaveBalances(balances: data.map((d) => d.toDomain()).toList(), pagination: pagination.toDomain());
  }
}
