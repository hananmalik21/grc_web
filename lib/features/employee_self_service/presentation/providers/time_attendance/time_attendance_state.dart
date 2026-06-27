import 'package:grc/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum AttendanceRecordStatus { present, late, absent }

extension AttendanceRecordStatusX on AttendanceRecordStatus {
  String get label {
    return switch (this) {
      AttendanceRecordStatus.present => 'Present',
      AttendanceRecordStatus.late => 'Late',
      AttendanceRecordStatus.absent => 'Absent',
    };
  }

  Color get textColor {
    return switch (this) {
      AttendanceRecordStatus.present => AppColors.greenTextSecondary,
      AttendanceRecordStatus.late => AppColors.warningText,
      AttendanceRecordStatus.absent => AppColors.redTextSecondary,
    };
  }

  Color get backgroundColor {
    return switch (this) {
      AttendanceRecordStatus.present => AppColors.greenBg,
      AttendanceRecordStatus.late => AppColors.warningBg,
      AttendanceRecordStatus.absent => AppColors.redBg,
    };
  }

  Color get borderColor {
    return switch (this) {
      AttendanceRecordStatus.present => AppColors.greenBorder,
      AttendanceRecordStatus.late => AppColors.warningBorder,
      AttendanceRecordStatus.absent => AppColors.redBorder,
    };
  }
}

class TimeAttendanceSummaryStat {
  const TimeAttendanceSummaryStat({required this.label, required this.value, required this.iconPath});

  final String label;
  final String value;
  final String iconPath;
}

class TimeAttendanceVerificationInfo {
  const TimeAttendanceVerificationInfo({
    required this.label,
    required this.value,
    required this.badgeLabel,
    required this.iconPath,
  });

  final String label;
  final String value;
  final String badgeLabel;
  final String iconPath;
}

class TimeAttendanceGeofenceInfo {
  const TimeAttendanceGeofenceInfo({
    required this.title,
    required this.perimeterLabel,
    required this.badgeLabel,
    required this.latitude,
    required this.longitude,
  });

  final String title;
  final String perimeterLabel;
  final String badgeLabel;
  final String latitude;
  final String longitude;
}

class TimeAttendanceShiftInfo {
  const TimeAttendanceShiftInfo({
    required this.shiftName,
    required this.workingHours,
    required this.breakTime,
    required this.gracePeriod,
  });

  final String shiftName;
  final String workingHours;
  final String breakTime;
  final String gracePeriod;
}

class AttendanceHistoryRecord {
  const AttendanceHistoryRecord({
    required this.id,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.hours,
    required this.status,
    required this.source,
  });

  final String id;
  final DateTime date;
  final String checkIn;
  final String checkOut;
  final String hours;
  final AttendanceRecordStatus status;
  final String source;
}

class TimeAttendanceState {
  const TimeAttendanceState({
    required this.headerTitle,
    required this.headerSubtitle,
    required this.currentServerTime,
    required this.availableMonths,
    required this.selectedMonth,
    required this.verificationInfo,
    required this.checkInTime,
    required this.checkOutTime,
    required this.isClockedIn,
    required this.verificationCaption,
    required this.geofenceInfo,
    required this.shiftInfo,
    required this.summaryStats,
    required this.records,
  });

  final String headerTitle;
  final String headerSubtitle;
  final DateTime currentServerTime;
  final List<DateTime> availableMonths;
  final DateTime selectedMonth;
  final TimeAttendanceVerificationInfo verificationInfo;
  final String? checkInTime;
  final String? checkOutTime;
  final bool isClockedIn;
  final String verificationCaption;
  final TimeAttendanceGeofenceInfo geofenceInfo;
  final TimeAttendanceShiftInfo shiftInfo;
  final List<TimeAttendanceSummaryStat> summaryStats;
  final List<AttendanceHistoryRecord> records;

  List<AttendanceHistoryRecord> get filteredRecords {
    return records
        .where((record) => record.date.year == selectedMonth.year && record.date.month == selectedMonth.month)
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  TimeAttendanceState copyWith({
    String? headerTitle,
    String? headerSubtitle,
    DateTime? currentServerTime,
    List<DateTime>? availableMonths,
    DateTime? selectedMonth,
    TimeAttendanceVerificationInfo? verificationInfo,
    String? checkInTime,
    bool clearCheckInTime = false,
    String? checkOutTime,
    bool clearCheckOutTime = false,
    bool? isClockedIn,
    String? verificationCaption,
    TimeAttendanceGeofenceInfo? geofenceInfo,
    TimeAttendanceShiftInfo? shiftInfo,
    List<TimeAttendanceSummaryStat>? summaryStats,
    List<AttendanceHistoryRecord>? records,
  }) {
    return TimeAttendanceState(
      headerTitle: headerTitle ?? this.headerTitle,
      headerSubtitle: headerSubtitle ?? this.headerSubtitle,
      currentServerTime: currentServerTime ?? this.currentServerTime,
      availableMonths: availableMonths ?? this.availableMonths,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      verificationInfo: verificationInfo ?? this.verificationInfo,
      checkInTime: clearCheckInTime ? null : (checkInTime ?? this.checkInTime),
      checkOutTime: clearCheckOutTime ? null : (checkOutTime ?? this.checkOutTime),
      isClockedIn: isClockedIn ?? this.isClockedIn,
      verificationCaption: verificationCaption ?? this.verificationCaption,
      geofenceInfo: geofenceInfo ?? this.geofenceInfo,
      shiftInfo: shiftInfo ?? this.shiftInfo,
      summaryStats: summaryStats ?? this.summaryStats,
      records: records ?? this.records,
    );
  }
}
