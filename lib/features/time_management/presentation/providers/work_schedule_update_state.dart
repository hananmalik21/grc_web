import 'package:grc/core/enums/position_status.dart';
import 'package:grc/core/enums/time_management_enums.dart';
import 'package:grc/features/time_management/domain/models/shift.dart';
import 'package:grc/features/time_management/domain/models/time_zone.dart';
import 'package:grc/features/time_management/domain/models/work_pattern.dart';

class WorkScheduleUpdateState {
  final String scheduleCode;
  final String scheduleNameEn;
  final String scheduleNameAr;
  final String effectiveStartDate;
  final String effectiveEndDate;
  final TimeZone? selectedTimeZone;
  final WorkPattern? selectedWorkPattern;
  final PositionStatus selectedStatus;
  final WorkScheduleAssignmentMode assignmentMode;
  final Map<int, ShiftOverview?> dayShifts;
  final ShiftOverview? sameShiftForAllDays;
  final bool isUpdating;
  final String? error;

  const WorkScheduleUpdateState({
    this.scheduleCode = '',
    this.scheduleNameEn = '',
    this.scheduleNameAr = '',
    this.effectiveStartDate = '',
    this.effectiveEndDate = '',
    this.selectedTimeZone,
    this.selectedWorkPattern,
    this.selectedStatus = PositionStatus.active,
    this.assignmentMode = WorkScheduleAssignmentMode.perDayShift,
    this.dayShifts = const {},
    this.sameShiftForAllDays,
    this.isUpdating = false,
    this.error,
  });

  WorkScheduleUpdateState copyWith({
    String? scheduleCode,
    String? scheduleNameEn,
    String? scheduleNameAr,
    String? effectiveStartDate,
    String? effectiveEndDate,
    TimeZone? selectedTimeZone,
    bool clearTimeZone = false,
    WorkPattern? selectedWorkPattern,
    bool clearWorkPattern = false,
    PositionStatus? selectedStatus,
    WorkScheduleAssignmentMode? assignmentMode,
    Map<int, ShiftOverview?>? dayShifts,
    bool clearDayShifts = false,
    ShiftOverview? sameShiftForAllDays,
    bool clearSameShift = false,
    bool? isUpdating,
    String? error,
    bool clearError = false,
  }) {
    return WorkScheduleUpdateState(
      scheduleCode: scheduleCode ?? this.scheduleCode,
      scheduleNameEn: scheduleNameEn ?? this.scheduleNameEn,
      scheduleNameAr: scheduleNameAr ?? this.scheduleNameAr,
      effectiveStartDate: effectiveStartDate ?? this.effectiveStartDate,
      effectiveEndDate: effectiveEndDate ?? this.effectiveEndDate,
      selectedTimeZone: clearTimeZone ? null : (selectedTimeZone ?? this.selectedTimeZone),
      selectedWorkPattern: clearWorkPattern ? null : (selectedWorkPattern ?? this.selectedWorkPattern),
      selectedStatus: selectedStatus ?? this.selectedStatus,
      assignmentMode: assignmentMode ?? this.assignmentMode,
      dayShifts: clearDayShifts ? {} : (dayShifts ?? this.dayShifts),
      sameShiftForAllDays: clearSameShift ? null : (sameShiftForAllDays ?? this.sameShiftForAllDays),
      isUpdating: isUpdating ?? this.isUpdating,
      error: clearError ? null : (error ?? this.error),
    );
  }

  WorkScheduleUpdateState reset() {
    return const WorkScheduleUpdateState();
  }
}
