import 'dart:async';

import 'package:grc/features/employee_self_service/presentation/providers/time_attendance/time_attendance_state.dart';
import 'package:grc/gen/assets.gen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class TimeAttendanceNotifier extends StateNotifier<TimeAttendanceState> {
  TimeAttendanceNotifier() : super(_initialState()) {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state.copyWith(currentServerTime: state.currentServerTime.add(const Duration(seconds: 1)));
    });
  }

  late final Timer _timer;

  static TimeAttendanceState _initialState() {
    return TimeAttendanceState(
      headerTitle: 'Time & Attendance',
      headerSubtitle: 'View your attendance records and clock in/out',
      currentServerTime: DateTime(2026, 3, 6, 1, 23, 46),
      availableMonths: [DateTime(2026, 3, 1), DateTime(2026, 2, 1), DateTime(2026, 1, 1)],
      selectedMonth: DateTime(2026, 3, 1),
      verificationInfo: TimeAttendanceVerificationInfo(
        label: 'Verification Level',
        value: 'AI Face + GPS + Bio',
        badgeLabel: 'Secure',
        iconPath: Assets.icons.auth.secureShield.path,
      ),
      checkInTime: null,
      checkOutTime: null,
      isClockedIn: false,
      verificationCaption: 'Verified by Geofence, AI Face ID & Biometrics',
      geofenceInfo: const TimeAttendanceGeofenceInfo(
        title: 'Geofence Status',
        perimeterLabel: 'Within Work Perimeter (250m)',
        badgeLabel: 'SAFE',
        latitude: '29.3759',
        longitude: '47.9774',
      ),
      shiftInfo: const TimeAttendanceShiftInfo(
        shiftName: 'Standard Morning (G1)',
        workingHours: '08:00 - 16:00',
        breakTime: '1 Hour (Flexible)',
        gracePeriod: '15 Minutes',
      ),
      summaryStats: [
        TimeAttendanceSummaryStat(label: 'Present Days', value: '0', iconPath: Assets.icons.attendance.present.path),
        TimeAttendanceSummaryStat(label: 'Late Arrivals', value: '0', iconPath: Assets.icons.attendance.late.path),
        TimeAttendanceSummaryStat(label: 'Total Hours', value: '0.0', iconPath: Assets.icons.clockIcon.path),
        TimeAttendanceSummaryStat(label: 'Overtime (h)', value: '0.0', iconPath: Assets.icons.addIcon.path),
      ],
      records: [
        AttendanceHistoryRecord(
          id: 'att-001',
          date: DateTime(2026, 2, 25),
          checkIn: '08:03',
          checkOut: '16:14',
          hours: '8.2',
          status: AttendanceRecordStatus.present,
          source: 'Geofence',
        ),
        AttendanceHistoryRecord(
          id: 'att-002',
          date: DateTime(2026, 2, 24),
          checkIn: '08:19',
          checkOut: '16:00',
          hours: '7.7',
          status: AttendanceRecordStatus.late,
          source: 'Biometric',
        ),
        AttendanceHistoryRecord(
          id: 'att-003',
          date: DateTime(2026, 2, 23),
          checkIn: '--:--',
          checkOut: '--:--',
          hours: '0.0',
          status: AttendanceRecordStatus.absent,
          source: 'System',
        ),
      ],
    );
  }

  void setSelectedMonth(DateTime value) {
    state = state.copyWith(
      selectedMonth: value,
      summaryStats: _buildSummaryStats(
        records: state.records
            .where((record) => record.date.year == value.year && record.date.month == value.month)
            .toList(),
      ),
    );
  }

  void toggleClockState() {
    final formattedTime = DateFormat('HH:mm').format(state.currentServerTime);

    if (state.isClockedIn) {
      state = state.copyWith(isClockedIn: false, checkOutTime: formattedTime);
      return;
    }

    state = state.copyWith(isClockedIn: true, checkInTime: formattedTime, clearCheckOutTime: true);
  }

  List<TimeAttendanceSummaryStat> _buildSummaryStats({required List<AttendanceHistoryRecord> records}) {
    final presentCount = records.where((record) => record.status == AttendanceRecordStatus.present).length;
    final lateCount = records.where((record) => record.status == AttendanceRecordStatus.late).length;
    final totalHours = records.fold<double>(0, (sum, record) => sum + (double.tryParse(record.hours) ?? 0));
    final overtimeHours = records.fold<double>(0, (sum, record) {
      final parsed = double.tryParse(record.hours) ?? 0;
      return parsed > 8 ? sum + (parsed - 8) : sum;
    });

    return [
      TimeAttendanceSummaryStat(label: 'Present Days', value: '$presentCount', iconPath: Assets.icons.tasksIcon.path),
      TimeAttendanceSummaryStat(
        label: 'Late Arrivals',
        value: '$lateCount',
        iconPath: Assets.icons.attendance.late.path,
      ),
      TimeAttendanceSummaryStat(
        label: 'Total Hours',
        value: totalHours.toStringAsFixed(1),
        iconPath: Assets.icons.attendance.halfDay.path,
      ),
      TimeAttendanceSummaryStat(
        label: 'Overtime (h)',
        value: overtimeHours.toStringAsFixed(1),
        iconPath: Assets.icons.addDivisionIcon.path,
      ),
    ];
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

final timeAttendanceProvider = StateNotifierProvider.autoDispose<TimeAttendanceNotifier, TimeAttendanceState>((ref) {
  return TimeAttendanceNotifier();
});
