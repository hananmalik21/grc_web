import 'package:grc/features/leave_management/data/dto/paginated_leave_requests_dto.dart';
import 'package:grc/features/leave_management/domain/models/leave_balance_summary.dart';

class LeaveBalanceSummaryItemDto {
  final int employeeId;
  final String employeeGuid;
  final String employeeNumber;
  final String employeeName;
  final String department;
  final String? joinDate;
  final num annualLeave;
  final num sickLeave;
  final num totalAvailable;

  const LeaveBalanceSummaryItemDto({
    required this.employeeId,
    required this.employeeGuid,
    required this.employeeNumber,
    required this.employeeName,
    required this.department,
    this.joinDate,
    this.annualLeave = 0,
    this.sickLeave = 0,
    this.totalAvailable = 0,
  });

  factory LeaveBalanceSummaryItemDto.fromJson(Map<String, dynamic> json) {
    num parseNum(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v;
      if (v is String) return num.tryParse(v) ?? 0;
      return 0;
    }

    String stringKey(String key) => json[key] as String? ?? json[_camel(key)] as String? ?? '';
    String? stringKeyOrNull(String key) => json[key] as String? ?? json[_camel(key)] as String?;
    int intKey(String key) => (json[key] as num?)?.toInt() ?? (json[_camel(key)] as num?)?.toInt() ?? 0;
    num numKey(String key) => parseNum(json[key] ?? json[_camel(key)]);

    return LeaveBalanceSummaryItemDto(
      employeeId: intKey('employee_id'),
      employeeGuid: stringKey('employee_guid'),
      employeeNumber: stringKey('employee_number'),
      employeeName: stringKey('employee_name'),
      department: stringKey('department'),
      joinDate: stringKeyOrNull('join_date'),
      annualLeave: numKey('annual_leave'),
      sickLeave: numKey('sick_leave'),
      totalAvailable: numKey('total_available'),
    );
  }

  static String _camel(String snake) {
    final parts = snake.split('_');
    if (parts.isEmpty) return snake;
    return parts.first.toLowerCase() +
        parts
            .skip(1)
            .map((p) => p.isEmpty ? p : '${p[0].toUpperCase()}${p.length > 1 ? p.substring(1).toLowerCase() : ''}')
            .join();
  }

  LeaveBalanceSummaryItem toDomain() {
    DateTime? parsedJoinDate;
    if (joinDate != null && joinDate!.isNotEmpty) {
      parsedJoinDate = DateTime.tryParse(joinDate!);
    }
    return LeaveBalanceSummaryItem(
      employeeId: employeeId,
      employeeGuid: employeeGuid,
      employeeNumber: employeeNumber,
      employeeName: employeeName,
      department: department,
      joinDate: parsedJoinDate,
      annualLeave: annualLeave.toDouble(),
      sickLeave: sickLeave.toDouble(),
      totalAvailable: totalAvailable.toDouble(),
    );
  }
}

class LeaveBalanceSummaryResponseDto {
  final bool success;
  final String message;
  final List<LeaveBalanceSummaryItemDto> data;
  final PaginationInfoDto pagination;

  const LeaveBalanceSummaryResponseDto({
    required this.success,
    required this.message,
    required this.data,
    required this.pagination,
  });

  factory LeaveBalanceSummaryResponseDto.fromJson(Map<String, dynamic> json) {
    final meta = json['meta'] as Map<String, dynamic>? ?? {};
    final paginationJson = meta['pagination'] as Map<String, dynamic>? ?? {};

    return LeaveBalanceSummaryResponseDto(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => LeaveBalanceSummaryItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationInfoDto.fromJson(paginationJson),
    );
  }

  PaginatedLeaveBalanceSummaries toDomain() {
    return PaginatedLeaveBalanceSummaries(
      items: data.map((d) => d.toDomain()).toList(),
      pagination: pagination.toDomain(),
    );
  }
}
