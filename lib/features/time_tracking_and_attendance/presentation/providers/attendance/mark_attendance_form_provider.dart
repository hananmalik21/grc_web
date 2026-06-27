import 'package:grc/core/network/exceptions.dart';
import 'package:grc/core/services/location_service.dart';
import 'package:grc/core/utils/date_time_utils.dart';
import 'package:grc/core/services/toast_service.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/attendance_record.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/models/attendance/manual_attendance_request.dart';
import 'package:grc/features/time_tracking_and_attendance/domain/repositories/attendance_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

extension _DateTimeTimeOfDayX on DateTime {
  TimeOfDay toTimeOfDay() => TimeOfDay.fromDateTime(this);
}

abstract class PrefilledFieldKey {
  static const scheduleStartTime = 'scheduleStartTime';
  static const scheduleDuration = 'scheduleDuration';
  static const status = 'status';
  static const checkInTime = 'checkInTime';
  static const checkOutTime = 'checkOutTime';
  static const location = 'location';
  static const notes = 'notes';
}

class MarkAttendanceFormState {
  final int? attendanceDayId;
  final int? employeeId;
  final String? employeeName;
  final String? employeeNumber;
  final DateTime? date;
  final TimeOfDay? scheduleStartTime;
  final int? scheduleDuration;
  final AttendanceStatus? status;
  final TimeOfDay? checkInTime;
  final TimeOfDay? checkOutTime;
  final String? location;
  final String? notes;
  final bool isLoading;
  final bool isFetchingByDate;
  final bool dateFetchSucceeded;
  final Set<String> prefilledFieldKeys;
  final bool isStatusMissing;

  const MarkAttendanceFormState({
    this.attendanceDayId,
    this.employeeId,
    this.employeeName,
    this.employeeNumber,
    this.date,
    this.scheduleStartTime,
    this.scheduleDuration,
    this.status,
    this.checkInTime,
    this.checkOutTime,
    this.location,
    this.notes,
    this.isLoading = false,
    this.isFetchingByDate = false,
    this.dateFetchSucceeded = false,
    this.prefilledFieldKeys = const {},
    this.isStatusMissing = false,
  });

  bool isFieldPrefilled(String key) => prefilledFieldKeys.contains(key);

  MarkAttendanceFormState copyWith({
    int? attendanceDayId,
    int? employeeId,
    String? employeeName,
    String? employeeNumber,
    DateTime? date,
    TimeOfDay? scheduleStartTime,
    int? scheduleDuration,
    AttendanceStatus? status,
    TimeOfDay? checkInTime,
    TimeOfDay? checkOutTime,
    String? location,
    String? notes,
    bool? isLoading,
    bool? isFetchingByDate,
    bool? dateFetchSucceeded,
    Set<String>? prefilledFieldKeys,
    bool? isStatusMissing,
  }) {
    return MarkAttendanceFormState(
      attendanceDayId: attendanceDayId ?? this.attendanceDayId,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      employeeNumber: employeeNumber ?? this.employeeNumber,
      date: date ?? this.date,
      scheduleStartTime: scheduleStartTime ?? this.scheduleStartTime,
      scheduleDuration: scheduleDuration ?? this.scheduleDuration,
      status: status ?? this.status,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      location: location ?? this.location,
      notes: notes ?? this.notes,
      isLoading: isLoading ?? this.isLoading,
      isFetchingByDate: isFetchingByDate ?? this.isFetchingByDate,
      dateFetchSucceeded: dateFetchSucceeded ?? this.dateFetchSucceeded,
      prefilledFieldKeys: prefilledFieldKeys ?? this.prefilledFieldKeys,
      isStatusMissing: isStatusMissing ?? this.isStatusMissing,
    );
  }
}

class MarkAttendanceFormNotifier extends StateNotifier<MarkAttendanceFormState> {
  MarkAttendanceFormNotifier() : super(const MarkAttendanceFormState());

  void initializeFromAttendance(Attendance attendance) {
    final prefilled = <String>{};
    prefilled.add(PrefilledFieldKey.status);
    if (attendance.clockIn != null) prefilled.add(PrefilledFieldKey.checkInTime);
    if (attendance.clockOut != null) prefilled.add(PrefilledFieldKey.checkOutTime);
    final loc = attendance.checkInLocation?.city ?? attendance.checkInLocation?.address;
    if (loc != null && loc.isNotEmpty) prefilled.add(PrefilledFieldKey.location);
    if (attendance.notes != null && attendance.notes!.isNotEmpty) prefilled.add(PrefilledFieldKey.notes);

    state = MarkAttendanceFormState(
      attendanceDayId: attendance.attendanceDayId,
      employeeId: attendance.employeeId,
      employeeName: attendance.employeeName,
      employeeNumber: attendance.employeeNumber,
      date: attendance.date,
      scheduleStartTime: null,
      scheduleDuration: null,
      status: attendance.status,
      checkInTime: attendance.clockIn != null ? TimeOfDay.fromDateTime(attendance.clockIn!) : null,
      checkOutTime: attendance.clockOut != null ? TimeOfDay.fromDateTime(attendance.clockOut!) : null,
      location: attendance.checkInLocation?.city ?? attendance.checkInLocation?.address,
      notes: attendance.notes,
      dateFetchSucceeded: true,
      prefilledFieldKeys: prefilled,
    );
  }

  /// Initializes form from AttendanceRecord (listing API response).
  /// Schedule fields come only from schedule_obj; actual fields from actual_obj.
  void initializeFromAttendanceRecord(AttendanceRecord record) {
    final attendance = record.attendance;
    if (attendance == null) return;

    final prefilled = <String>{};
    if (record.scheduleStartTimeAsDateTime != null) prefilled.add(PrefilledFieldKey.scheduleStartTime);
    if (record.scheduledHoursAsInt != null) prefilled.add(PrefilledFieldKey.scheduleDuration);
    prefilled.add(PrefilledFieldKey.status);
    if (attendance.clockIn != null) prefilled.add(PrefilledFieldKey.checkInTime);
    if (attendance.clockOut != null) prefilled.add(PrefilledFieldKey.checkOutTime);
    final loc = attendance.checkInLocation?.city ?? attendance.checkInLocation?.address;
    if (loc != null && loc.isNotEmpty) prefilled.add(PrefilledFieldKey.location);
    if (attendance.notes != null && attendance.notes!.isNotEmpty) prefilled.add(PrefilledFieldKey.notes);

    state = MarkAttendanceFormState(
      attendanceDayId: record.attendanceDayId,
      employeeId: attendance.employeeId,
      employeeName: attendance.employeeName,
      employeeNumber: attendance.employeeNumber,
      date: attendance.date,
      scheduleStartTime: record.scheduleStartTimeAsDateTime != null
          ? TimeOfDay.fromDateTime(record.scheduleStartTimeAsDateTime!)
          : null,
      scheduleDuration: record.scheduledHoursAsInt,
      status: attendance.status,
      checkInTime: attendance.clockIn != null ? TimeOfDay.fromDateTime(attendance.clockIn!) : null,
      checkOutTime: attendance.clockOut != null ? TimeOfDay.fromDateTime(attendance.clockOut!) : null,
      location: attendance.checkInLocation?.city ?? attendance.checkInLocation?.address,
      notes: attendance.notes,
      dateFetchSucceeded: true,
      prefilledFieldKeys: prefilled,
    );
  }

  void setEmployee(int? id, String? name, String? number) {
    final changed = state.employeeId != id;
    state = state.copyWith(
      employeeId: id,
      employeeName: name,
      employeeNumber: number,
      date: changed ? null : state.date,
      attendanceDayId: changed ? null : state.attendanceDayId,
      scheduleStartTime: changed ? null : state.scheduleStartTime,
      scheduleDuration: changed ? null : state.scheduleDuration,
      status: changed ? null : state.status,
      checkInTime: changed ? null : state.checkInTime,
      checkOutTime: changed ? null : state.checkOutTime,
      prefilledFieldKeys: changed ? {} : state.prefilledFieldKeys,
      dateFetchSucceeded: changed ? false : state.dateFetchSucceeded,
    );
  }

  void setDate(DateTime? date) {
    state = state.copyWith(date: date, prefilledFieldKeys: {}, dateFetchSucceeded: false);
  }

  Future<void> fetchAndPrefillForDate(
    BuildContext context, {
    required DateTime date,
    required AttendanceRepository repository,
    required int enterpriseId,
    required int employeeId,
  }) async {
    state = state.copyWith(isFetchingByDate: true);
    try {
      final result = await repository.getAttendanceByDate(
        enterpriseId: enterpriseId,
        employeeId: employeeId,
        attendanceDate: date,
      );
      if (result == null) {
        _clearPrefilledFieldsForNoData();
        return;
      }
      final prefilled = <String>{};
      if (result.scheduleStartTime != null) prefilled.add(PrefilledFieldKey.scheduleStartTime);
      if (result.scheduledHours != null) prefilled.add(PrefilledFieldKey.scheduleDuration);
      prefilled.add(PrefilledFieldKey.status);
      if (result.checkInTime != null) prefilled.add(PrefilledFieldKey.checkInTime);
      if (result.checkOutTime != null) prefilled.add(PrefilledFieldKey.checkOutTime);

      final statusWasProvided = result.attendanceStatus?.isNotEmpty ?? false;
      state = MarkAttendanceFormState(
        attendanceDayId: result.attendanceDayId > 0 ? result.attendanceDayId : null,
        employeeId: state.employeeId,
        employeeName: state.employeeName,
        employeeNumber: state.employeeNumber,
        date: state.date,
        scheduleStartTime: result.scheduleStartTime?.toTimeOfDay(),
        scheduleDuration: result.scheduledHours?.toInt(),
        status: statusWasProvided ? Attendance.parseStatus(result.attendanceStatus!) : AttendanceStatus.absent,
        checkInTime: result.checkInTime?.toTimeOfDay(),
        checkOutTime: result.checkOutTime?.toTimeOfDay(),
        location: state.location,
        notes: state.notes,
        isFetchingByDate: false,
        dateFetchSucceeded: true,
        prefilledFieldKeys: prefilled,
        isStatusMissing: !statusWasProvided,
      );
    } on AppException catch (e) {
      _clearPrefilledFieldsOnError();
      if (context.mounted) ToastService.error(context, e.message);
    } catch (_) {
      _clearPrefilledFieldsOnError();
      if (context.mounted) ToastService.error(context, 'Failed to load attendance for this date');
    } finally {
      state = state.copyWith(isFetchingByDate: false);
    }
  }

  void _clearPrefilledFieldsForNoData() {
    state = MarkAttendanceFormState(
      attendanceDayId: null,
      employeeId: state.employeeId,
      employeeName: state.employeeName,
      employeeNumber: state.employeeNumber,
      date: state.date,
      scheduleStartTime: null,
      scheduleDuration: null,
      status: null,
      checkInTime: null,
      checkOutTime: null,
      location: state.location,
      notes: state.notes,
      isLoading: state.isLoading,
      isFetchingByDate: state.isFetchingByDate,
      dateFetchSucceeded: true,
      prefilledFieldKeys: const {},
    );
  }

  void _clearPrefilledFieldsOnError() {
    state = MarkAttendanceFormState(
      attendanceDayId: null,
      employeeId: state.employeeId,
      employeeName: state.employeeName,
      employeeNumber: state.employeeNumber,
      date: state.date,
      scheduleStartTime: null,
      scheduleDuration: null,
      status: null,
      checkInTime: null,
      checkOutTime: null,
      location: state.location,
      notes: state.notes,
      isLoading: state.isLoading,
      isFetchingByDate: state.isFetchingByDate,
      dateFetchSucceeded: false,
      prefilledFieldKeys: const {},
    );
  }

  void setScheduleStartTime(TimeOfDay? time) {
    state = state.copyWith(scheduleStartTime: time);
  }

  void setScheduleDuration(int? duration) {
    state = state.copyWith(scheduleDuration: duration);
  }

  void setStatus(AttendanceStatus? status) {
    state = state.copyWith(status: status);
  }

  void setCheckInTime(TimeOfDay? time) {
    state = state.copyWith(checkInTime: time);
  }

  void setCheckOutTime(TimeOfDay? time) {
    state = state.copyWith(checkOutTime: time);
  }

  void setLocation(String? location) {
    state = state.copyWith(location: location);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void reset() {
    state = const MarkAttendanceFormState();
  }

  Future<void> submit(
    BuildContext context, {
    required AttendanceRepository repository,
    required int? enterpriseId,
    LocationData? userLocation,
    VoidCallback? onSuccess,
  }) async {
    if (state.employeeId == null || state.employeeName == null) {
      ToastService.error(context, 'Please select an employee');
      return;
    }
    if (state.date == null) {
      ToastService.error(context, 'Please select a date');
      return;
    }
    if (state.status == null) {
      ToastService.error(context, 'Please select a status');
      return;
    }
    if (state.checkInTime == null) {
      ToastService.error(context, 'Please select check-in time');
      return;
    }
    if (state.checkOutTime == null) {
      ToastService.error(context, 'Please select check-out time');
      return;
    }
    if (state.location == null || state.location!.isEmpty) {
      ToastService.error(context, 'Please enter location');
      return;
    }
    if (enterpriseId == null) {
      ToastService.error(context, 'Please select an enterprise first');
      return;
    }

    int? attendanceDayId = state.attendanceDayId != null && state.attendanceDayId! > 0 ? state.attendanceDayId : null;
    if (attendanceDayId == null) {
      final empNum = state.employeeNumber ?? '';
      if (empNum.isEmpty) {
        ToastService.error(context, 'Employee number is required');
        return;
      }
      state = state.copyWith(isLoading: true);
      try {
        attendanceDayId = await repository.getAttendanceDayIdForEmployeeDate(
          enterpriseId: enterpriseId,
          employeeNumber: empNum,
          date: state.date!,
        );
      } finally {
        state = state.copyWith(isLoading: false);
      }
      if (attendanceDayId == null) {
        if (context.mounted) {
          ToastService.error(
            context,
            'No attendance day found for this employee and date. Ensure the employee has a schedule for the selected date.',
          );
        }
        return;
      }
      state = state.copyWith(attendanceDayId: attendanceDayId);
    }

    state = state.copyWith(isLoading: true);
    try {
      final date = state.date!;
      final checkInDt = DateTime(date.year, date.month, date.day, state.checkInTime!.hour, state.checkInTime!.minute);
      final checkOutDt = DateTime(
        date.year,
        date.month,
        date.day,
        state.checkOutTime!.hour,
        state.checkOutTime!.minute,
      );
      final checkInStr = DateTimeUtils.localToIso8601WithOffset(checkInDt);
      final checkOutStr = DateTimeUtils.localToIso8601WithOffset(checkOutDt);

      const fallbackLat = 29.3759;
      const fallbackLon = 47.9774;
      final lat = userLocation?.latitude ?? fallbackLat;
      final lon = userLocation?.longitude ?? fallbackLon;
      final location = state.location ?? 'Office';

      final request = ManualAttendanceRequest(
        attendanceDayId: attendanceDayId,
        checkInTime: checkInStr,
        checkOutTime: checkOutStr,
        actor: 'HR_ADMIN',
        locationNameIn: location,
        latitudeIn: lat,
        longitudeIn: lon,
        locationNameOut: location,
        latitudeOut: lat,
        longitudeOut: lon,
        reason: state.notes,
      );

      await repository.submitManualAttendance(request);
      onSuccess?.call();
      if (context.mounted) {
        ToastService.success(context, 'Attendance saved successfully');
        context.pop();
      }
    } on AppException catch (e) {
      if (context.mounted) ToastService.error(context, e.message);
    } catch (e) {
      if (context.mounted) ToastService.error(context, 'Failed to save attendance');
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}

final markAttendanceFormProvider = StateNotifierProvider<MarkAttendanceFormNotifier, MarkAttendanceFormState>((ref) {
  return MarkAttendanceFormNotifier();
});
