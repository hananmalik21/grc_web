import 'package:grc/core/network/api_client.dart';
import 'package:grc/core/network/api_config.dart';
import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/core/network/api_endpoints.dart';
import 'package:grc/core/network/exceptions.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/attendance_by_date_dto.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/attendance_log_dto.dart';
import 'package:grc/features/time_tracking_and_attendance/data/dto/manual_attendance_request_dto.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_by_date.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_log_page.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/manual_attendance_request.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final ApiClient _apiClient;

  AttendanceRepositoryImpl({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient(baseUrl: ApiConfig.baseUrl);
  @override
  Future<List<Attendance>> getAttendance({
    required DateTime fromDate,
    required DateTime toDate,
    String? companyId,
    String? orgUnitId,
    String? levelCode,
    String? employeeNumber,
  }) async {
    return [];
  }

  @override
  Future<AttendanceLogPage> getAttendanceLogs({
    required int enterpriseId,
    int page = 1,
    int pageSize = 25,
    DateTime? fromDate,
    DateTime? toDate,
    String? orgUnitId,
    String? levelCode,
    String? employeeNumber,
  }) async {
    try {
      final query = <String, String>{
        'enterpriseId': enterpriseId.toString(),
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      };
      if (fromDate != null) {
        query['fromDate'] = fromDate.toIso8601String().split('T').first;
      }
      if (toDate != null) {
        query['toDate'] = toDate.toIso8601String().split('T').first;
      }
      if (orgUnitId != null && orgUnitId.isNotEmpty) {
        query['orgUnitId'] = orgUnitId;
      }
      if (levelCode != null && levelCode.isNotEmpty) {
        query['levelCode'] = levelCode;
      }
      if (employeeNumber != null && employeeNumber.trim().isNotEmpty) {
        query['employeeNumber'] = employeeNumber.trim();
      }

      final response = await _apiClient.get(ApiEndpoints.tmAttendanceLogs, queryParameters: query);

      final dto = AttendanceLogsResponseDto.fromJson(response);
      final records = dto.items.map((e) => e.toDomain()).toList();

      return AttendanceLogPage(
        records: records,
        page: dto.pagination.page,
        pageSize: dto.pagination.pageSize,
        total: dto.pagination.total,
        totalPages: dto.pagination.totalPages,
        hasNext: dto.pagination.hasNext,
        hasPrevious: dto.pagination.hasPrevious,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to load attendance logs: ${e.toString()}', originalError: e);
    }
  }

  @override
  Future<AttendanceByDate?> getAttendanceByDate({
    required int enterpriseId,
    required int employeeId,
    required DateTime attendanceDate,
  }) async {
    try {
      final query = <String, String>{
        'enterpriseId': enterpriseId.toString(),
        'attendanceDate': attendanceDate.toIso8601String().split('T').first,
        'employeeId': employeeId.toString(),
      };
      final response = await _apiClient.get(ApiEndpoints.tmAttendanceLogsByDate, queryParameters: query);
      final dto = AttendanceByDateDto.fromApiResponse(response);
      if (dto.attendanceDay == null) return null;
      return _mapToDomain(dto);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to fetch attendance by date: ${e.toString()}', originalError: e);
    }
  }

  AttendanceByDate _mapToDomain(AttendanceByDateDto dto) {
    final day = dto.attendanceDay!;
    final schedule = dto.schedule;
    final actual = dto.actual;
    return AttendanceByDate(
      attendanceDayId: day.attendanceDayId > 0 ? day.attendanceDayId : 0,
      attendanceStatus: day.attendanceStatus,
      inState: day.inState,
      outState: day.outState,
      scheduleStartTime: schedule != null ? DateTimeUtils.parseLocalTimeString(schedule.scheduleStartTime) : null,
      scheduleEndTime: schedule != null ? DateTimeUtils.parseLocalTimeString(schedule.scheduleEndTime) : null,
      scheduledHours: schedule?.scheduledHours?.toDouble(),
      checkInTime: actual != null ? DateTimeUtils.parseLocalTimeString(actual.checkInTime) : null,
      checkOutTime: actual != null ? DateTimeUtils.parseLocalTimeString(actual.checkOutTime) : null,
      hoursWorked: actual?.hoursWorked?.toDouble(),
      overtimeHours: actual?.overtimeHours?.toDouble(),
    );
  }

  @override
  Future<int?> getAttendanceDayIdForEmployeeDate({
    required int enterpriseId,
    required String employeeNumber,
    required DateTime date,
  }) async {
    final page = await getAttendanceLogs(
      enterpriseId: enterpriseId,
      page: 1,
      pageSize: 50,
      fromDate: date,
      toDate: date,
      employeeNumber: employeeNumber,
    );
    final target = date.toIso8601String().split('T').first;
    for (final r in page.records) {
      final dayId = r.attendanceDayId;
      if (dayId != null && dayId > 0 && r.date.toIso8601String().startsWith(target)) {
        return dayId;
      }
    }
    return null;
  }

  @override
  Future<void> submitManualAttendance(ManualAttendanceRequest request) async {
    try {
      final dto = ManualAttendanceRequestDto.fromDomain(request);
      await _apiClient.post(ApiEndpoints.tmAttendanceManual, body: dto.toJson());
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException('Failed to save attendance: ${e.toString()}', originalError: e);
    }
  }
}
