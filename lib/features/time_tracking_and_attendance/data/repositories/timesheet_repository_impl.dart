import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/timesheet_dto.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/timesheet_stats_dto.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_page.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_stats.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/timesheet/timesheet_status.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/repositories/timesheet_repository.dart';

class TimesheetRepositoryImpl implements TimesheetRepository {
  final ApiClient _apiClient;

  TimesheetRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  @override
  Future<TimesheetPage> getTimesheets({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? searchQuery,
    TimesheetStatus? status,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
    String? orgUnitId,
    String? levelCode,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final query = <String, String>{
        'enterpriseId': companyId ?? '1',
        'page': page.toString(),
        'limit': pageSize.toString(),
      };

      if (searchQuery != null && searchQuery.trim().isNotEmpty) {
        query['search'] = searchQuery.trim();
      }

      if (status != null) {
        query['status'] = status.toApiString();
      }

      if (weekStartDate != null) {
        query['weekStartFrom'] = DateTimeUtils.formatYmd(weekStartDate);
      }

      if (weekEndDate != null) {
        query['weekStartTo'] = DateTimeUtils.formatYmd(weekEndDate);
      }

      if (orgUnitId != null && orgUnitId.isNotEmpty) {
        query['orgUnitId'] = orgUnitId;
      }

      if (levelCode != null && levelCode.isNotEmpty) {
        query['levelCode'] = levelCode;
      }

      final response = await _apiClient.get(ApiEndpoints.tmTimesheets, queryParameters: query);

      final data = response['data'] as List<dynamic>? ?? [];
      final pagination = (response['meta']?['pagination'] as Map<String, dynamic>?) ?? {};

      final items = data.whereType<Map<String, dynamic>>().map((e) => TimesheetDto.fromJson(e).toDomain()).toList();

      final total = pagination['total'] as int? ?? items.length;
      final currentPage = pagination['page'] as int? ?? page;
      final limit = pagination['limit'] as int? ?? pageSize;
      final hasMore = pagination['hasMore'] as bool? ?? false;

      return TimesheetPage(items: items, total: total, page: currentPage, pageSize: limit, hasMore: hasMore);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to load timesheets: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<TimesheetStats> getTimesheetStatistics({
    DateTime? weekStartDate,
    DateTime? weekEndDate,
    String? employeeNumber,
    String? companyId,
    String? divisionId,
    String? departmentId,
    String? sectionId,
  }) async {
    try {
      final enterpriseId = companyId?.trim().isNotEmpty == true ? companyId! : '1';
      final query = <String, String>{'enterprise_id': enterpriseId};
      final response = await _apiClient.get(ApiEndpoints.tmTimesheetsStats, queryParameters: query);
      final data = response['data'] as Map<String, dynamic>? ?? {};
      final dto = TimesheetStatsDto.fromJson(data);
      return dto.toDomain();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch timesheet stats: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Timesheet> getTimesheetById(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mock implementation
    return Timesheet(
      id: timesheetId,
      guid: '',
      employeeId: 1,
      employeeName: 'Ahmed Al-Mutairi',
      employeeNumber: 'EMP-001',
      departmentName: 'IT',
      weekStartDate: DateTime(2024, 12, 9),
      weekEndDate: DateTime(2024, 12, 15),
      regularHours: 40.0,
      overtimeHours: 2.0,
      totalHours: 42.0,
      status: TimesheetStatus.approved,
    );
  }

  @override
  Future<Timesheet> createTimesheet(Map<String, dynamic> timesheetData) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.tmTimesheets, body: timesheetData);

      final status = response['status'] as bool? ?? true;
      if (!status) {
        final message = response['message'] as String? ?? 'Failed to create timesheet';
        throw UnknownException(message);
      }

      final data = response['data'] as Map<String, dynamic>? ?? {};

      DateTime parseDate(String? value) {
        if (value == null || value.isEmpty) {
          return DateTime.now();
        }
        try {
          return DateTime.parse(value);
        } catch (_) {
          return DateTime.now();
        }
      }

      final weekStart = parseDate(timesheetData['week_start_date'] as String?);
      final weekEnd = parseDate(timesheetData['week_end_date'] as String?);

      final lines = (timesheetData['lines'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().toList();

      final regularHours = lines
          .map((l) => (l['regular_hours'] as num?)?.toDouble() ?? 0.0)
          .fold<double>(0.0, (a, b) => a + b);
      final overtimeHours = lines
          .map((l) => (l['ot_hours'] as num?)?.toDouble() ?? 0.0)
          .fold<double>(0.0, (a, b) => a + b);
      final totalHours = regularHours + overtimeHours;

      final statusCode = (timesheetData['status_code'] as String?) ?? 'draft';

      return Timesheet(
        id: (data['timesheet_id'] as num?)?.toInt() ?? 0,
        guid: data['timesheet_guid'] as String? ?? '',
        employeeId: (timesheetData['employee_id'] as num?)?.toInt() ?? 0,
        employeeName: '',
        employeeNumber: '',
        departmentName: '',
        weekStartDate: weekStart,
        weekEndDate: weekEnd,
        regularHours: regularHours,
        overtimeHours: overtimeHours,
        totalHours: totalHours,
        status: TimesheetStatusExtension.fromString(statusCode),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to create timesheet: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Timesheet> updateTimesheet(String timesheetGuid, Map<String, dynamic> timesheetData) async {
    try {
      final response = await _apiClient.put(ApiEndpoints.tmTimesheetByGuid(timesheetGuid), body: timesheetData);
      final status = response['status'] as bool? ?? true;
      if (!status) {
        final message = response['message'] as String? ?? 'Failed to update timesheet';
        throw UnknownException(message);
      }
      final data = response['data'] as Map<String, dynamic>? ?? {};
      DateTime parseDate(String? value) {
        if (value == null || value.isEmpty) return DateTime.now();
        try {
          return DateTime.parse(value);
        } catch (_) {
          return DateTime.now();
        }
      }

      final weekStart = parseDate(timesheetData['week_start_date'] as String?);
      final weekEnd = parseDate(timesheetData['week_end_date'] as String?);
      final lines = (timesheetData['lines'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().toList();
      final regularHours = lines
          .map((l) => (l['regular_hours'] as num?)?.toDouble() ?? 0.0)
          .fold<double>(0.0, (a, b) => a + b);
      final overtimeHours = lines
          .map((l) => (l['ot_hours'] as num?)?.toDouble() ?? 0.0)
          .fold<double>(0.0, (a, b) => a + b);
      final statusCode = (timesheetData['status_code'] as String?) ?? 'draft';
      return Timesheet(
        id: (data['timesheet_id'] as num?)?.toInt() ?? 0,
        guid: (data['timesheet_guid'] as String?) ?? timesheetGuid,
        employeeId: (timesheetData['employee_id'] as num?)?.toInt() ?? 0,
        employeeName: '',
        employeeNumber: '',
        departmentName: '',
        weekStartDate: weekStart,
        weekEndDate: weekEnd,
        regularHours: regularHours,
        overtimeHours: overtimeHours,
        totalHours: regularHours + overtimeHours,
        status: TimesheetStatusExtension.fromString(statusCode),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to update timesheet: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<Timesheet> submitTimesheet(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    throw UnimplementedError('submitTimesheet not implemented');
  }

  @override
  Future<void> approveTimesheet(String timesheetGuid) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.tmTimesheetApprove(timesheetGuid),
        body: {'updated_by': 'API_USER'},
      );
      final status = response['status'] as bool? ?? true;
      if (!status) {
        final message = response['message'] as String? ?? 'Failed to approve timesheet';
        throw UnknownException(message);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to approve timesheet: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> rejectTimesheet(String timesheetGuid, {required String rejectReason}) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.tmTimesheetReject(timesheetGuid),
        body: {'updated_by': 'admin', 'reject_reason': rejectReason},
      );
      final status = response['status'] as bool? ?? true;
      if (!status) {
        final message = response['message'] as String? ?? 'Failed to reject timesheet';
        throw UnknownException(message);
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to reject timesheet: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<void> deleteTimesheet(int timesheetId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Mock implementation
    throw UnimplementedError('deleteTimesheet not implemented');
  }
}
